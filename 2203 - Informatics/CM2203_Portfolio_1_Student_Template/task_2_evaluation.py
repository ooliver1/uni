# Task 2 [10 points out of 40] Classifier evaluation
# This task focuses on evaluating the naïve Bayes classifier from Task 1. On your own, implement binary precision,
# recall and f-measure, as well as their macro and weighted counterparts.
# You are also asked to implement the multiclass version of accuracy, and its weighted counterpart. You
# need to follow the formulas covered in the module. Remember to be mindful of edge cases (the approach for handling
# them is explained in lecture slides).
# Please note that this template also contains empty functions pertaining to
# creating a confusion matrix and calculating TPs, FPs and FNs based on it. These will be implemented during the
# practicals, with the code to be released later. They are not a part of the marking criteria.

import pandas as pd


# This function computes the confusion matrix based on the provided series of actual and predicted classes.
# The returned data frame must contain appropriate column and row names, and be filled with integers.
# The columns correspond to actual classes and rows to predicted classes, in the sense that the i-th row
# is the row representing how often entries actually belonging to some class, were predicted as the i-th class value;
# the i-th column represents how often entries predicted as some other class, actually belonged to the i-th class.
#
# At input, function takes:
# - actual_class, predicted_class - series of class values representing actual and predicted classes of some dataset.
#                                   NOT guaranteed to contain all possible class values from the classification schema.
# - class_values - all possible values of the class from which actual_class and predicted_class were drawn.
#
# As output, it produces:
# - matrix : a data frame representing the confusion matrix computed based on the offered series of actual
#            and predicted classes. The data frame must contain appropriate column and row names, and be
#            filled with integers.

def confusion_matrix(actual_class: pd.Series, predicted_class: pd.Series, class_values: list[str]) -> pd.DataFrame:
    matrix = pd.DataFrame(0, index=class_values, columns=class_values)

    for i in range(len(actual_class)):
        try:
            actual = actual_class.iloc[i]
            predicted = predicted_class.iloc[i]
        except:
            print("Dataset contains a class not in the classification scheme!")
        value = matrix.loc[predicted, actual]
        matrix.loc[predicted, actual] = value + 1
    return matrix


# These functions compute per-class true positives and false positives/negatives based on the provided confusion matrix.
#
# As input, these functions take:
# - matrix - a data frame representing the confusion matrix computed based on the offered series of actual
#            and predicted classes. See confusion_matrix function for description.
#
# As output, these functions produce:
# - tps/fps/fns - dictionaries that for every class value in the classification scheme (corresponding to names of
#                 all rows and/or all columns in the matrix) return the true positive, false positive or
#                 false negative values for that class.

def compute_TPs(matrix: pd.DataFrame) -> dict[str, int]:
    class_vals = matrix.columns
    tps = {}
    for class_v in class_vals:
    # TPs is simply about retrieving values from the diagonal
    # .loc retrieves values via names, not indices
        tps[class_v] = matrix.loc[class_v, class_v]
    return tps


def compute_FPs(matrix: pd.DataFrame) -> dict[str, int]:
    class_vals = matrix.columns
    fps = {}
    for class_1 in class_vals:
        sum_vals = 0
        for class_2 in class_vals:
        # For FPs, we need to add up values predicted to belong to that class, but not belonging to it in reality
            if class_1 != class_2:
                sum_vals += matrix.loc[class_1, class_2]
        fps[class_1] = sum_vals
    return fps


def compute_FNs(matrix: pd.DataFrame) -> dict[str, int]:
    class_vals = matrix.columns
    fns = {}
    for class_1 in class_vals:
        sum_vals = 0
        # For FNs, we need to add up values not predicted to belong to that class, but belonging to it in reality
        for class_2 in class_vals:
            if class_1 != class_2:
                sum_vals += matrix.loc[class_2, class_1]
        fns[class_1] = sum_vals
    return fns


# These functions compute the binary measures based on the provided values. Not all measures use all the values.
# Do not remove the unused variables from the function pattern.
# At input, the functions take:
# - tp, fp, fn : the single values of true positives, false positive and negatives
#
# As output, they produce:
# - binary precision/recall/f-measure - appropriate evaluation measure created using the binary approach.

def compute_binary_precision(tp: int, fp: int, fn: int) -> float:
    return tp / (tp + fp)


def compute_binary_recall(tp: int, fp: int, fn: int) -> float:
    return tp / (tp + fn)


def compute_binary_f_measure(tp: int, fp: int, fn: int) -> float:
    precision = compute_binary_precision(tp, fp, fn)
    recall = compute_binary_recall(tp, fp, fn)
    return 2 * (precision * recall) / (precision + recall)


# These functions compute the macro precision, macro recall, macro f-measure, based on the offered confusion matrix.
# You are expected to use appropriate binary counterparts when needed (binary recall for macro recall, binary precision
# for macro precision, binary f-measure for macro f-measure) and the functions for computing tps/fps/fns as needed.
#
# As input, these functions take:
# - matrix - a data frame representing the confusion matrix computed based on the offered series of actual
#            and predicted classes. See confusion_matrix function for description.
# As output, they produce:
# - macro precision/recall/f-measure - appropriate evaluation measures created using the macro average approach.

def compute_macro_precision(matrix: pd.DataFrame) -> float:
    tps = compute_TPs(matrix)
    fps = compute_FPs(matrix)
    fns = compute_FNs(matrix)

    per_class = [
        compute_binary_precision(tp, fp, fn)
        for tp, fp, fn in zip(tps.values(), fps.values(), fns.values())
    ]

    return sum(per_class) / len(per_class) if per_class else 0.0

def compute_macro_recall(matrix: pd.DataFrame) -> float:
    tps = compute_TPs(matrix)
    fps = compute_FPs(matrix)
    fns = compute_FNs(matrix)

    per_class = [
        compute_binary_recall(tp, fp, fn)
        for tp, fp, fn in zip(tps.values(), fps.values(), fns.values())
    ]

    return sum(per_class) / len(per_class) if per_class else 0.0


def compute_macro_f_measure(matrix: pd.DataFrame) -> float:
    tps = compute_TPs(matrix)
    fps = compute_FPs(matrix)
    fns = compute_FNs(matrix)

    per_class = [
        compute_binary_f_measure(tp, fp, fn)
        for tp, fp, fn in zip(tps.values(), fps.values(), fns.values())
    ]

    return sum(per_class) / len(per_class) if per_class else 0.0


# These functions compute the weighted precision, macro recall, macro f-measure, based on the offered confusion matrix.
# You are expected to use appropriate binary counterparts when needed (binary recall for weighted recall,
# binary precision for weighted precision, binary f-measure for weighted f-measure) and the functions
# for computing tps/fps/fns as needed.
#
# As input, these functions take:
# - matrix - a data frame representing the confusion matrix computed based on the offered series of actual
#            and predicted classes. See confusion_matrix function for description.
# As output, they produce:
# - weighted precision/recall/f-measure - appropriate evaluation measures created using the weighted average approach.

def compute_weighted_precision(matrix: pd.DataFrame) -> float:
    tps = compute_TPs(matrix)
    fps = compute_FPs(matrix)
    fns = compute_FNs(matrix)

    class_weighting = matrix.sum()
    total_records = class_weighting.sum()
    print(class_weighting)

    if total_records == 0:
        return 0.0

    weighted_precision = sum(
        compute_binary_precision(tp, fp, fn) * weight
        for tp, fp, fn, weight in zip(tps.values(), fps.values(), fns.values(), class_weighting.values)
    ) / total_records

    return weighted_precision


def compute_weighted_recall(matrix: pd.DataFrame) -> float:
    tps = compute_TPs(matrix)
    fps = compute_FPs(matrix)
    fns = compute_FNs(matrix)

    class_weighting = matrix.sum()
    total_records = class_weighting.sum()

    if total_records == 0:
        return 0.0

    weighted_recall = sum(
        compute_binary_recall(tp, fp, fn) * weight
        for tp, fp, fn, weight in zip(tps.values(), fps.values(), fns.values(), class_weighting.values)
    ) / total_records

    return weighted_recall


def compute_weighted_f_measure(matrix: pd.DataFrame) -> float:
    tps = compute_TPs(matrix)
    fps = compute_FPs(matrix)
    fns = compute_FNs(matrix)

    class_weighting = matrix.sum()
    total_records = class_weighting.sum()

    if total_records == 0:
        return 0.0

    weighted_f_measure = sum(
        compute_binary_f_measure(tp, fp, fn) * weight
        for tp, fp, fn, weight in zip(tps.values(), fps.values(), fns.values(), class_weighting.values)
    ) / total_records

    return weighted_f_measure


# These functions compute the standard and balanced multiclass accuracies based on the offered confusion matrix.
# You are expected to use appropriately select and use the functions defined previously.
#
# As input, these functions take:
# - matrix - a data frame representing the confusion matrix computed based on the offered series of actual
#            and predicted classes. See confusion_matrix function for description.
# As output, they produce:
# - standard/balanced multiclass accuracy - appropriate evaluation measures created using the
#                                           standard/balanced approach.


def compute_standard_accuracy(matrix: pd.DataFrame) -> float:
    tps = sum(compute_TPs(matrix).values())
    total = matrix.sum().sum()

    if total == 0:
        return 0.0

    return tps / total


def compute_balanced_accuracy(matrix: pd.DataFrame) -> float:
    tps = compute_TPs(matrix)
    fps = compute_FPs(matrix)
    fns = compute_FNs(matrix)

    total_accuracy = 0

    total_accuracy = sum(
        compute_binary_recall(tp, fp, fn)
        for tp, fp, fn in zip(tps.values(), fps.values(), fns.values())
    )

    return total_accuracy / len(matrix.index) if len(matrix.index) > 0 else 0.0


# In this function you are expected to compute precision, recall, f-measure and accuracy of your classifier using
# the macro average approach.
# At input, the function takes:
# - actual_class - a pandas Series of actual class values
# - predicted_class - a pandas Series of predicted class values
# - class_values - a list of all possible class values (actual and predicted classes are not guaranteed to be complete)
# - confusion_func - function to be invoked to compute the confusion matrix
# Function outputs:
# - computed measures - a dictionary of measures, explicitly listing 'macro_precision', 'macro_recall',
#                       'macro_f_measure', 'weighted_precision', 'weighted_recall', 'weighted_f_measure',
#                       'standard_accuracy' and 'balanced_accuracy'

def evaluate_classification(actual_class: pd.Series, predicted_class: pd.Series, class_values: list[str],
                            confusion_func=confusion_matrix) \
        -> dict[str, float]:
    # Have fun with the computations!
    macro_precision = -1.0
    macro_recall = -1.0
    macro_f_measure = -1.0

    weighted_precision = -1.0
    weighted_recall = -1.0
    weighted_f_measure = -1.0

    standard_accuracy = -1.0
    balanced_accuracy = -1.0
    # once ready, we return the values
    return {'macro_precision': macro_precision, 'macro_recall': macro_recall, 'macro_f_measure': macro_f_measure,
            'weighted_precision': weighted_precision, 'weighted_recall': weighted_recall,
            'weighted_f_measure': weighted_f_measure, 'standard_accuracy': standard_accuracy,
            'balanced_accuracy': balanced_accuracy}
