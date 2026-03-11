# Task 1 [15 points out of 40] Naïve Bayes classifier

# Your first task is to implement the naïve Bayes classifier on your own. This involves calculating all the necessary
# probabilities from the provided data, and using them to make predictions for new unseen records.
# The required version is the one covered in the module. Implementing other naïve Bayes approaches (e.g. Gaussian) or
# using further modifications that do not correspond to the technique practiced in the module will lead to
# significant loss of points.
# The template contains a range of functions you must implement and use appropriately for this task. The template also
# uses a range of functions implemented by the module leader to support you in this task.

import pandas as pd


class NaiveBayes:

    # This function simply initializes an instance of NaiveBayes class. The constructor takes at input:
    # - class_info - pair that contains the name of the class column and its permitted values
    # - feature_info - dictionary that states attribute names and their permitted values

    def __init__(self, class_info: tuple[str, list[str]], feature_info: dict[str, list[str]]):
        self.class_info = class_info
        self.feature_info = feature_info
        # You can add further variables/attributes/etc. here
        self.class_probability: dict[str, float] = {}
        # {attr: {attrValue: {classValue: prob}}}
        self.attr_given_class: dict[str, dict[str, dict[str, float]]] = {}

    # This function trains the model, aka calculates all the necessary probabilities that a naive Bayes model needs.
    # How you store the computed probabilities internally is up to you - you may want to extend the init function.
    # For the purpose of this task, numerical values are treated just like categorical ones. Any new training
    # should purge old data.
    # At input, train_model takes:
    # - training_data - a pandas DataFrame that contains all the attribute values and class value for a given entry
    def train_model(self, training_data: pd.DataFrame):
        # Reset probabilities
        self.class_probability = {}
        self.attr_given_class = {}

        # Get class probabilities.
        self.class_probability = training_data[self.class_info[0]].value_counts(normalize=True).to_dict()

        # Get attribute probabilities given class.
        for attr in self.feature_info.keys():
            probabilities = training_data.groupby(self.class_info[0])[attr].value_counts(normalize=True).unstack(fill_value=0).to_dict()
            self.attr_given_class[attr] = probabilities

    # This function predicts the classes for entries in the training_data and produces an extended data frame.
    # At input, it takes:
    # - training_data - a pandas DataFrame that contains all the attribute values and class value for a given entry
    # The function outputs:
    # classified_data - a pandas DataFrame which expands the training_data by adding the "PredictedClass" column
    #                   that for every entry states the class value predicted for that entry. In case of ties,
    #                   the chosen class is the one that appears earlier alphabetically.
    def predict(self, testing_data: pd.DataFrame) -> pd.DataFrame:
        classified_data = testing_data.copy()
        probabilities = {}
        for class_value in self.class_info[1]:
            # P(c|A1,A2,...) = P(c) * P(A1|c) * P(A2|c) * ...
            probabilities[class_value] = self.retrieve_class_probability(class_value)
            for attr in self.feature_info.keys():
                attr_value = testing_data[attr].values[0]
                probabilities[class_value] *= self.retrieve_conditional_probability(class_value, attr, attr_value)

        # Choose the class with the highest probability
        # Compare their value along with the class name, to handle if they are equal.
        # If they are equal then take the first one alphabetically.
        predicted_class = (None, 0)
        for class_value, probability in probabilities.items():
            if (
                predicted_class is None
                or probability > predicted_class[1]
                or (probability == predicted_class[1] and class_value < predicted_class[0])
            ):
                predicted_class = (class_value, probability)

        classified_data["PredictedClass"] = predicted_class[0]
        return classified_data

    # The function returns the probability of a given class value. You can assume
    # that this function simply retrieves the desired probability after training rather than
    # recomputes them from scratch. A value of 0 should be returned if no training took place.
    # At input, it takes:
    # - class_value - the class value for which we want to calculate the probability
    # The function outputs:
    # - probability - float representing the probability of the given class value
    def retrieve_class_probability(self, class_value: str) -> float:
        return self.class_probability.get(class_value, 0.0)

    # The function returns the conditional probably of a feature value assuming a given class value. You can assume
    # that this function simply retrieves the desired probability after training rather than
    # recomputes them from scratch. A value of 0 should be returned if no training took place.
    # At input, it takes:
    # - class_value - the class value on which the feature_value is conditional
    # - feature_name - the name of the feature we want to calculate for
    # - feature_value - the feature value we want to calculate the conditional probability for
    # The function outputs:
    # - probability - float representing the calculated conditional probability
    #
    def retrieve_conditional_probability(self, class_value: str, feature_name: str, feature_value: str) -> float:
        return self.attr_given_class.get(feature_name, {}).get(feature_value, {}).get(class_value, 0.0)
