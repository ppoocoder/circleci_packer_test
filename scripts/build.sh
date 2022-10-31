#!/bin/bash
set -e

# load our helper functions
source scripts/common.sh

# check that the tools we require are present
package_check

# 
# base.sh DIR TARGET BASE_NAME
DIR="$1"
NAME="$2"
BASE_REGION="$3"
BASE_NAME="$4"

if [[ -z "$DIR" ]]; then
    echo "please specify the directory as first runtime argument"
    exit 1
fi
if [[ -z "$NAME" ]]; then
    echo "please specify the name as second runtime argument"
    exit 1
fi
if [[ -z "$BASE_NAME" ]]; then
    echo "No base AMI given"
else    
    BASE_BUILT=$(base_rebuilt $BASE_NAME)
    echo  "base_built :: $BASE_BUILT"
    echo "$BASE_NAME :: base-name!!!!"
    more manifest-$BASE_NAME.json
    AMI_BASE=$(get_base_ami "$BASE_BUILT" "$DIR" "$BASE_NAME" )
    echo "ami base :: $AMI_BASE  "
fi
echo "latest $DIR build already exists: $TAG_EXISTS"

echo "---------------------------------------1222233222211"
SHA=$(git ls-tree HEAD "$DIR" | cut -d" " -f3 | cut -f1)
echo "$SHA"
TAG_EXISTS=$(tag_exists $SHA)
echo "$TAG_EXISTS"
REGION=$BASE_REGION
echo "AWS_REGION   :  ${REGION}"

if [ "$TAG_EXISTS" = "false" ]; then
    packer build -var "aws_region=us-west-2" ${NAME}
else
    touch manifest-${DIR}.json
fi
