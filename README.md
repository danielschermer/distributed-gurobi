# Distributed Optimization with Gurobi on a Slurm Cluster

A simple batch script to make [Distributed Optimization with Gurobi](https://www.gurobi.com/solutions/distributed-optimization/) with an [academic license](https://support.gurobi.com/hc/en-us/articles/4408438050705-How-do-I-create-a-cluster-of-distributed-workers-as-an-academic) possible on a compute cluster running [Slurm](https://slurm.schedmd.com/documentation.html).

## Getting Started

The script assumes the following project structure:
```
$HOME
├── project
│   ├── distributed_gurobi.sbatch
│   ├── data
│   │   │── ...
│   ├── instances
│       ├── a.mps.gz
│       │── b.mps.gz
│       │── ...
│       
├── ...
```

The file `distributed-gurobi.sh` most likely requires slight adjustments, relating to:
1. The `#SBATCH` header, specifying the requested resources.
2. `MAIN_PORT` and `SUB_PORT`.
3. If the cluster has a dedicated module for Gurobi, it may be sufficient to adjust, `module load gurobi/latest`. Otherwise, `grb_rs` and `gurobi_cl` must be appended to `$PATH` in any other way.

A job can be submitted to the Slurm scheduler by running the following command from the `project` folder:

```sbatch distributed_gurobi.sbatch instances/a.mps.gz```



## References
Based on information made available by [Gurobi](https://www.gurobi.com/wp-content/plugins/hd_documentations/documentation/11.0/remoteservices.pdf) and the [University of Luxembourg](https://ulhpc-tutorials.readthedocs.io/en/latest/maths/Cplex-Gurobi/).
