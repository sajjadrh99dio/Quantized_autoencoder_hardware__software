# Quantized_autoencoder_hardware__software
Software and hardware implementation of a quantized Auto-Encoder using MLP neural networks for image Compression on MNIST and NotMNIST datasets in Python and SystemVerilog.

![Screenshot (1100)](https://github.com/user-attachments/assets/4d1ad492-f502-4a4b-9e50-8cfb3453419f)

This Project shows all the necessary steps for Hardware implementation of Neural networks on a simple MLP based Auto-Encoder.
 <br />
  <br />
In this project an auto-encoder model for compressing images is first trained using MNIST Dataset (for comparisons), then a quantized model is trained using quantized inputs and quantization-aware training. Afterwards, the weights of the quantized model is saved and the model is implemented in SystemVerilog.
 <br />
  <br />
 **Please note that the selected bitwidth for weights is 7 bits but can be easily altered.**
 <br />
  <br />
The overall architecture of the network can seen below.
    <br />
    <br />
<img src="https://github.com/user-attachments/assets/af6e3d1e-5cfe-49e1-b573-83c4ea57da2d" width="500" height="250" />
    <br />
    <br />

 Then the Procedure is repeated for NotMNIST Dataset aswell.
     <br />
      <br />
<img src="https://github.com/user-attachments/assets/bcae3a65-3c7e-4a88-9d8d-109989245c3d" width="500" height="250" />
     <br />
      <br />
  Example outputs of the module can be seen below
     <br />
      <br />
  <img src="https://github.com/user-attachments/assets/8ef78f46-d569-461d-a865-f260f60006cf" width="500" height="250" />
