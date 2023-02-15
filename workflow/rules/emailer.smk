rule emailer:
	input:
		expand("{latest_folder}/end_final.txt", latest_folder=latest_folder)
	output:
		expand("{outdir}/sent.txt", outdir=outdir)

	resources:
		mem_mb = 5048,
		tmpdir=config["temp_dir"]

	shell:
		"python3 {config[workflow_dir]}/workflow/scripts/emailer.py -f {config[output_dir]}/$(ls {config[output_dir]} -rt | tail -n1) -c {config[workflow_dir]}/config/config_credentials.yaml -g {config[workflow_dir]}/ignore_list.txt && touch {output}"
