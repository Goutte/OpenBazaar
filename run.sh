# Market Info
MY_MARKET_IP=$(curl -s ifconfig.me)
MY_MARKET_PORT=12345

# Specify a seed URI or you will be put into demo mode
SEED_URI=tcp://seed.openbazaar.org:12345

# Run in local test mode if not production
MODE=production

# Store config file
STOREFILE=ppl/default

# Location of log directory
LOGDIR=logs

if which python2 2>/dev/null; then
    PYTHON=python2
else
    PYTHON=python
fi


if [ ! -d "$LOGDIR" ]; then
  mkdir $LOGDIR
fi

if [ $MODE == production ]; then
	
	$PYTHON node/tornadoloop.py $STOREFILE $MY_MARKET_IP -s $SEED_URI -p $MY_MARKET_PORT -l $LOGDIR/node.log &
	
else

	# Primary Market - No SEED_URI specified 
	$PYTHON node/tornadoloop.py $STOREFILE 127.0.0.1 -l $LOGDIR/demo_node1.log &
	
	# Demo Peer Market
	sleep 2
    STOREFILE2=ppl/s_tec
	$PYTHON node/tornadoloop.py $STOREFILE2 127.0.0.2 -s tcp://127.0.0.1:$MY_MARKET_PORT -l $LOGDIR/demo_node2.log &

	sleep 2
    STOREFILE3=ppl/genjix
	$PYTHON node/tornadoloop.py $STOREFILE3 127.0.0.3 -s tcp://127.0.0.1:$MY_MARKET_PORT -l $LOGDIR/demo_node3.log &

fi
