#!/usr/bin/env bash
host=$(hostname)
echo 'HOST:' $host

# set mount path
if [[ "$host" == 'bagai-ts-29l' ]]; then
  mount_root=/home/zhengbao/mnt/root
else
  mount_root=/mnt/root
fi

# activate env if needed
if [[ "$PATH" == *"tapas"* ]]; then
  echo "tapas env activated"
else
  echo "tapas env not activated"
  conda_base=$(conda info --base)
  source ${conda_base}/etc/profile.d/conda.sh
  conda activate tapas
fi

# wandb
export WANDB_API_KEY=9caada2c257feff1b6e6a519ad378be3994bc06a

python -m tapas.run_task_main \
  --task=SQA \
  --input_dir=../TaBERT/data/SQA_1.0 \
  --output_dir=${mount_root}/tapas/data \
  --bert_vocab_file=${mount_root}/tapas/pretrained_models/tapas_base/vocab.txt \
  --mode=create_data
