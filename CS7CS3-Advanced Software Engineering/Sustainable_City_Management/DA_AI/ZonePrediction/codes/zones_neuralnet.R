nw_lgth <- nrow(tot_cd1)
train_lgth <- round(nw_lgth - nw_lgth/4)
test_lgth <- train_lgth + 1
# Shuffle new dataset
shuffled <- tot_cd1[sample(1:nw_lgth),]

# Train-test split
train <- shuffled[1:train_lgth,]
test <- shuffled[test_lgth:nw_lgth,]


train <- data.matrix(train)
train_x <- t(train[,-1])
train_y <- train[,1]
train_array <- train_x
dim(train_array) <- c(28, 28, 1, ncol(train_x))
#View(train_y)
test__ <- data.matrix(test)
test_x <- t(test__[,-1])
test_y <- test__[,1]
test_array <- test_x
dim(test_array) <- c(28, 28, 1, ncol(test_x))

#Model generation

set.seed(100)
model1 <- mx.mlp(train_x, train_y, hidden_node=10, out_node=2, out_activation="softmax",        
                 num.round=50, array.batch.size=50, learning.rate=0.1, momentum=0.1,
                 eval.metric=mx.metric.accuracy)

#set.seed(random) to generate same results

predict_probs <- predict(model1, test_array)
predicted_labels <- max.col(t(predict_probs)) - 1
table(test__[,1], predicted_labels)
accuracy_prior <- sum(diag(table(test__[,1], predicted_labels)))/nrow(test)