#!/bin/bash -l
#SBATCH -J DistributedMIP
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=16
#SBATCH --constraint="EPYC_7262"
#SBATCH --mem=32G
#SBATCH --time=0:05:00
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err

export MAIN_PORT=12345
export SUB_PORT=12345
export MPS_FILE=$1
export GUROBI_INNER_LAUNCHER="gurobi_inner_${SLURM_JOBID}.sh"

cat << 'EOF' > ${GUROBI_INNER_LAUNCHER}
#!/bin/bash

# Assign the first Slurm node to act as Host of the cluster and Client that starts gurobi_cl
MAIN_NODE=$(scontrol show hostname ${SLURM_NODELIST} | head -n 1)

# Load the Gurobi module (gurobi_cl and grb_rs must be in $PATH)!
module load gurobi/latest

if [[ "$(hostname)" = ${MAIN_NODE} ]]; then
    # Initialize the worker
    echo Starting server on $(hostname)
    cd data/${SLURM_JOBID}
    mkdir $(hostname)
    cd $(hostname)
    grb_rs init    

    # Start the main server (first worker)
    grb_rs --worker --port ${MAIN_PORT} &

    # Wait for all other workers to wake up and move back to the working directory
    sleep 30
    cd ../../../

    # Call gurobi_cl (adjust further arguments, where necessary)
    gurobi_cl Threads=${SLURM_CPUS_PER_TASK} LogFile="grb_${SLURM_JOBID}.log" ResultFile="sol_${SLURM_JOBID}.sol" Workerpool=${MAIN_NODE}:${MAIN_PORT} DistributedMIPJobs=$((SLURM_NNODES)) ${MPS_FILE}
else
    # Wait for the main server to be awake
    sleep 5

    # Initialize the worker
    echo Starting Worker on $(hostname)
    cd data/${SLURM_JOBID}
    mkdir $(hostname)
    cd $(hostname)
    grb_rs init

    grb_rs --worker --port ${SUB_PORT} --join ${MAIN_NODE}:${MAIN_PORT} &
    wait
fi
EOF

# Make the file executable
chmod +x ${GUROBI_INNER_LAUNCHER}
# Create a data directory for the current job
mkdir data/${SLURM_JOBID}
# Launch processes and wait until a solution file is created by the gurobi_cl process
srun ${GUROBI_INNER_LAUNCHER} &
while [[ ! -e "sol_${SLURM_JOBID}.sol" ]]; do
    sleep 5
done
# Clean up
rm ${GUROBI_INNER_LAUNCHER}
