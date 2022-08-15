def train_elastic_net(X_train, y_train):

    from sklearn.linear_model import ElasticNet

    model = ElasticNet(random_state=43, alpha=0.01, l1_ratio=0.05, max_iter=10000, fit_intercept=True)
    model.fit(X_train, y_train)

    return model.coef_, model.intercept_