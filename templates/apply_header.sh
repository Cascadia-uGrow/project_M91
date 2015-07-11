if [ $# -lt 3 ] 
then
	echo "Need more data"
	exit 1
fi
SOURCE=${1}
TITLE=${2}
DESC=${3}
TARGET=${1}

cp $SOURCE pre_temp.$SOURCE.bak

cat $REPO_ROOT/templates/get.erl $SOURCE > header.temp
cat header.temp | sed "s/TITLE/$TITLE/g" | sed "s/DESC/$DESC/g" > $TARGET
rm header.temp
