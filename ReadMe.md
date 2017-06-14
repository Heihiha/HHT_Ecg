## Introduction
* 本程序用于对心电信号做emd提取后计算lf/hf和采样熵。
* 用于研究房颤手术术后的预后和心电信号之间的相关性。
* 本实验使用数据为128导联的心电信号，格式为mat。

## Usage
* 对于一个心电信号，调用generate_emd_segments.m提取出emd片段。然后调用calc_entropy.m计算采样熵，调用calc_mean_lfhf计算lf/hf。


## Files
* scripts:
  * **main.m**: 主函数。load数据后，对每一个导联分别计算，结果保存在一128*2的数组中。
  * **visualize**: 可视化，显示结果放在fig文件夹中。
* function:
  * **generate_emd_segments.m**: 从心电信号中提取去除QRS波群后做emd的第一层IMF片段。
  * **calc_entropy.m**: 利用generate_emd_segments的输出，计算采样熵。
  * **calc_mean_lfhf.m**: 计算emd片段低频高频比的均值。
  * qrs_detect2.m: QRS detector based on the P&T method.(Physionet Challenge 2014)
  * calc_lfhf.m: Calculates a the LF/HF-ratio for a given (linear) PSD Px over a given linear frequency range Fx.
  * SampEn.m: 计算采样熵。
* fig/:
  * a_lead_time.fig:a号病人，lead号导联在某一时间点的片段的信号和IMF。
  * a_lead_timefa.fig:a号病人，lead号导联在某一时间点的片段的IMF的频谱。
  * all_12_10fa.fig: 四位病人12号导联某一段频谱的分布对比。
  * emd.fig: 某段信号的emd分解。
  * classification.fig: 四位病人各128导联，在samEntropy和lfhf二维空间上的分布。
  * lfhf.fig: 四位病人lfhf按导联分布。
  * lfhf2.fig：lfhf横坐标为病人的分布。

## Performance
* 在1.8 GHz Intel Core i5机器上，完整跑完一个导联大概需要一分钟。
* 若在generate_emd_segments.m中，只对前面部分信号做emd，而不是一整条。可提升到每条40s。

## Attention
* 用于处理的信号的采样频率要足够高，本实验用的数据采样频率为1khz
* 如果想要提高计算速度，可以考虑改变generate_emd_segments.m，只对前面部分信号做emd，而不是一整条。
* 有些导联算出来偏离过大，可能是受干扰影响，可以对其单独处理，调整阈值来跳过干扰。

## Contact
* sqfzf69(At)163.com
