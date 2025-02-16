aws_region() {
  local region=$(aws configure get region)
  if [ -z "$region" ]; then
    log ERROR "AWS region is not configured." >&2
    exit 1
  fi
  echo "$region"
}

aws_account() {
  local account=$(aws sts get-caller-identity --query Account --output text)
  if [ -z "$account" ]; then
    log ERROR "AWS account is not configured. Check if AWS credentials are set up." >&2
    exit 1
  fi
  echo "$account"
}

aws_user() {
  local user=$(aws sts get-caller-identity --query Arn --output text 2>/dev/null | awk -F'/' '{print $NF}')
  if [ -z "$user" ]; then
    log ERROR "AWS user is not configured. Check if AWS credentials are set up." >&2
    exit 1
  fi
  echo "$user"
}