#!/usr/bin/env bash
host=$(hostname)
echo 'HOST:' $host

# set mount path
if [[ "$host" == 'bagai-ts-29l' ]]; then
  mount_root=~/mnt/root
else
  mount_root=/mnt/root
fi
data=${mount_root}/tapas/data/pretrain
bert_root=${mount_root}/tapas/pretrained_models/bert-base-uncased

python3 -m tapas.experiments.tapas_pretraining_experiment \
  --eval_batch_size=32 \
  --train_batch_size=1 \
  --tpu_iterations_per_loop=5000 \
  --num_eval_steps=100 \
  --save_checkpoints_steps=5000 \
  --num_train_examples=1 \
  --max_seq_length=128 \
  --input_file_train=${data}/train.tfrecord \
  --input_file_eval=${data}/test.tfrecord \
  --init_checkpoint=${bert_root}/bert_model.ckpt \
  --bert_config_file=${bert_root}/bert_config.json \
  --model_dir="..." \
  --compression_type="" \
  --do_train
