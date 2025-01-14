function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
%X 5000x400
%y 5000x1
%nn_params 10285x1
%Theta1 25x401
%Theta2 10x26

% ========================== no for loop ==========================
%forward propagation
##a1 = [ones(m,1), X]; %5000x401
##z2 = a1* Theta1'; %5000x25
##a2 = [ones(m,1), sigmoid(z2)]; %5000x26
##z3 = a2*Theta2'; %5000x10
##a3 = sigmoid(z3); %5000x10
##
##h = a3;
##%y 5000x1
##Y = zeros(m, num_labels); %5000x10
##
##for i=1:m
##    Y(i,y(i)) = 1;
##endfor
##
##J = sum(sum(-Y .* log(h) - (1-Y) .* log(1-h)))/m;
##%J = (1/m) * (-Y(:)'*log(h(:)) - (1-Y(:))'*log(1-h(:)));
##
##%regularization
##J += (sum(Theta1(:, 2:end)(:).^2) + sum(Theta2(:, 2:end)(:).^2)) *lambda/(2*m);
##
###backpropagation
##e3 = a3 - Y; %5000x10
##e2 = (e3*Theta2(:,2:end)).*sigmoidGradient(z2); %5000x25
##
##Denta1 = e2'*a1; %25x401 
##Denta2 = e3'*a2; %10x26
##
##Theta1_grad = Denta1/m;
##Theta2_grad = Denta2/m;
##
##Theta1_grad(:,2:end) += Theta1(:,2:end)*lambda/m;
##Theta2_grad(:,2:end) += Theta2(:,2:end)*lambda/m;
%===================================================================

%Theta1 25x401
%Theta2 10x26
a1 = [ones(m,1), X]; %5000x401
a2 = zeros(m, hidden_layer_size + 1); %5000x26
a3 = zeros(m, num_labels); %5000x10

e3 = zeros(m, num_labels); %5000x10
e2 = zeros(m, hidden_layer_size); %5000x25
%====================== with for loop ===============================
for t = 1:m
  Y = zeros(1,10); %1x10
 
  z2 = a1(t,:)* Theta1'; %1x25
  a2(t,:) = [1, sigmoid(z2)]; %1x26
  
  z3 = a2(t,:)*Theta2'; %1x10
  a3(t,:) = sigmoid(z3); %1x10

  h = a3(t,:); %1x10
  
  Y(y(t)) = 1; %1x10
  
  J += -Y*log(h)' - (1-Y)*log(1-h)';
  
  e3(t,:) = a3(t,:) - Y; %1x10
  e2(t,:) = e3(t,:)*Theta2(:,2:end).*sigmoidGradient(z2); %1x25

endfor
J /= m;

J += (sum(Theta1(:, 2:end)(:).^2) + sum(Theta2(:, 2:end)(:).^2)) *lambda/(2*m);

Denta1 = e2'*a1; %25x401 
Denta2 = e3'*a2; %10x26
  
Theta1_grad = (1/m)*Denta1;
Theta2_grad = (1/m)*Denta2;

Theta1_grad(:,2:end) += Theta1(:,2:end)*lambda/m;
Theta2_grad(:,2:end) += Theta2(:,2:end)*lambda/m;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
