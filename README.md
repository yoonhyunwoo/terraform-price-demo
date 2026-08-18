# terraform-price-demo

Consumer-side demo of [terraform-price](https://github.com/yoonhyunwoo/terraform-price)'s
GitHub Action: every pull request gets a monthly cost report with a delta against the
merge target, in the job step summary.

- `.github/workflows/cost.yml` — the entire integration (one `uses:` step)
- `terraform/` — throwaway HCL; PRs that change it change the delta table

This repo runs credentials-free, so price rows show as unresolved. Real consumers add a
`configure-aws-credentials` step (commented in the workflow) for live prices — any
credentials work, list prices are public.
