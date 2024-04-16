import argparse
import gurobipy as gp


if __name__ == "__main__":

    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-f", "--file", help="Path to the problem instance.", default=None, type=str
    )
    parser.add_argument(
        "-i", "--id", help="Slurm job ID used for solution and log file names.", default=0, type=int
    )
    parser.add_argument(
        "-t", "--timelimit", help="Limits the time (in seconds).", default=float("inf"), type=float
    )
    parser.add_argument(
        "-w", "--workerpool", help="Specifies the Remote Services cluster.", default="", type=str
    )
    parser.add_argument(
        "-n", "--threads", help="Controls the number of threads.", default=0, type=int
    )
    parser.add_argument(
        "-j", "--jobs", help="Controls the number of distributed MIP jobs.", default=0, type=int
    )
    args = parser.parse_args()

    # Load the model (or build one here)
    m = gp.read(args.file)

    # Adjust the necessary Gurobi parameters
    m.setParam("LogFile", f"{args.id}.log")
    m.setParam("TimeLimit", args.timelimit)
    m.setParam("Threads", args.threads)
    m.setParam("Workerpool", args.workerpool)
    m.setParam("DistributedMIPJobs", args.jobs)

    # Optimize the model and save the solution
    m.optimize()
    m.write(f"{args.id}.sol")
