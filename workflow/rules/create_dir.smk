import glob
import os.path
import datetime
import os
import sys

output_dir = config["output_dir"]
now = datetime.datetime.now()
now_str = now.strftime("%d%m%y")
outdir = f"{output_dir}/databases_logs_{now_str}"
init =  f"{output_dir}/run_workflow.txt"
if not os.path.exists(init):
	os.mkdir(init)

rule create_dir:
	input:
		expand("{init}", init=init)
	output:
		expand("{outdir}/start.txt", outdir=outdir)

	resources:
		mem_mb = 10048,
		tmpdir = config["temp_dir"]
	run:
		if not os.path.exists(outdir):
			os.mkdir(outdir)
		shell("touch {output}")
