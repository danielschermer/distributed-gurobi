# Distributed Optimization with Gurobi on a Slurm Cluster

A simple batch script to facilitate [Distributed Optimization with Gurobi](https://www.gurobi.com/solutions/distributed-optimization/) on a compute cluster running [Slurm](https://slurm.schedmd.com/documentation.html), utilizing an [academic license](https://support.gurobi.com/hc/en-us/articles/4408438050705-How-do-I-create-a-cluster-of-distributed-workers-as-an-academic).

Tested with Gurobi Optimizer 11.0 on a Rocky Linux 8.9 Cluster running Slurm 23.11.5.

## Getting Started

### Project Structure
Ensure that the `project` adheres to the following structure:
```
project
├── distributed-gurobi.sh
├── data
│   │── ...
├── instance.mps.gz
│── ...
```

### Customization
The file `distributed-gurobi.sh` must be adjusted to match the cluster's specifications.
This relates to:
1. The `#SBATCH` header,
2. the ports `MAIN_PORT` and `SUB_PORT`,
3. the `GUROBI_TIME_LIMIT`, which must match the requested resources (net of approximately 5 minutes to account for a graceful startup and shutdown).
4. When using Gurobi:
    * If `module load gurobi/latest` is not applicable, ensure that `grb_rs` and `gurobi_cl` are found in `$PATH`.
    * Alternatively, the file `main.py` can be called and adjusted, if necessary.
    * In any case, the proper Gurobi license must be available.



### Job Submission
A job can be submitted to the Slurm scheduler by running the following command from the `project` folder:

```
sbatch distributed-gurobi.sbatch instance.mps.gz
```




## References
Information sourced from [Gurobi's documentation](https://www.gurobi.com/wp-content/plugins/hd_documentations/documentation/11.0/remoteservices.pdf) and the [University of Luxembourg's tutorials](https://ulhpc-tutorials.readthedocs.io/en/latest/maths/Cplex-Gurobi/).
