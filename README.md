# Quantized_autoencoder_hardware__software
Software and hardware implementation of a quantized Auto-Encoder using MLP neural networks for image Compression on MNIST and NotMNIST datasets in Python and SystemVerilog.

![Screenshot (1100)](https://github.com/user-attachments/assets/4d1ad492-f502-4a4b-9e50-8cfb3453419f)

This Project shows all the necessary steps for Hardware implementation of Neural networks on a simple MLP based Auto-Encoder.
 <br />
  <br />
In this project an auto-encoder model for compressing images is first trained using MNIST Dataset (for comparisons), then a quantized model is trained using quantized inputs and quantization-aware training. Afterwards, the weights of the quantized model is saved and the model is implemented in SystemVerilog.
 <br />
 ** Please note that the selected bitwidth for weights is 7 bits but can be easily altered.
 <br />
  <br />
The overall architecture of the network can seen below.
    <br />
    <br />
<img src="https://github.com/user-attachments/assets/af6e3d1e-5cfe-49e1-b573-83c4ea57da2d" width="600" height="300" />
    <br />
    <br />

 Then the Procedure is repeated for NotMNIST Dataset aswell![Screenshot (1102)](https://github.com/user-attachments/assets/17605519-d7d5-4d2c-8482-cd4e7ca91e90)
. ![Screenshot (1101)](https://github.com/user-attachments/assets/3000afb0-ed9b-419a-a610-1b3acd76b3e0)
