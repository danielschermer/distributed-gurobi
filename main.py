import argparse
import gurobipy as gp


if __name__ == "__main__":

    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-f", "--file", help="Path to the problem instance.", default=None, type=str
    )
    parser.add_argument(
        "-t", "--timelimit", help="Limits the time (in seconds).", default=float("inf"), type=int
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

    # Adjust the required parameters
    m.setParam("TimeLimit", args.timelimit)
    m.setParam("Threads", args.threads)
    m.setParam("Workerpool", args.workerpool)
    m.setParam("DistributedMIPJobs", args.jobs)

    # Optimize the model
    m.optimize()

    # Store the solution
    m.write("model.sol")
