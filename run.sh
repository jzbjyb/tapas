#!/usr/bin/env bash
mount_root=/mnt/root
data_root=${mount_root}/tapas/data
model_root=${data_root}/wikisql_supervised/model
pretrained_root=${mount_root}/tapas/pretrained_models
init_ckp=$1
init_config=$2
model_dir=${model_root}/$3
num_train_examples=2500000  # 50000 * 50 epoch

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
  --task=WIKISQL_SUPERVISED \
  --output_dir=${data_root} \
  --init_checkpoint=${pretrained_root}/${init_ckp} \
  --bert_config_file=${pretrained_root}/${init_config} \
  --model_dir=${model_dir} \
  --mode=train \
  --train_batch_size 16 \
  --num_train_examples ${num_train_examples}
