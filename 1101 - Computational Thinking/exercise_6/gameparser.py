import string

# List of "unimportant" words (feel free to add more)
skip_words = [
    "a",
    "about",
    "all",
    "an",
    "another",
    "any",
    "around",
    "at",
    "bad",
    "beautiful",
    "been",
    "better",
    "big",
    "can",
    "every",
    "for",
    "from",
    "good",
    "have",
    "her",
    "here",
    "hers",
    "his",
    "how",
    "i",
    "if",
    "in",
    "into",
    "is",
    "it",
    "its",
    "large",
    "later",
    "like",
    "little",
    "main",
    "me",
    "mine",
    "more",
    "my",
    "now",
    "of",
    "off",
    "oh",
    "on",
    "please",
    "small",
    "some",
    "soon",
    "that",
    "the",
    "then",
    "this",
    "those",
    "through",
    "till",
    "to",
    "towards",
    "until",
    "us",
    "want",
    "we",
    "what",
    "when",
    "why",
    "wish",
    "with",
    "would",
]


def filter_words(words, skip_words):
    """This function takes a list of words and returns a copy of the list from
    which all words provided in the list skip_words have been removed.
    For example:

    >>> filter_words(["help", "me", "please"], ["me", "please"])
    ['help']

    >>> filter_words(["go", "south"], skip_words)
    ['go', 'south']

    >>> filter_words(['how', 'about', 'i', 'go', 'through', 'that', 'little', 'passage', 'to', 'the', 'south'], skip_words)
    ['go', 'passage', 'south']

    """
    filtered = []
    for word in words:
        if word not in skip_words:
            filtered.append(word)

    return filtered


def remove_punct(text):
    """This function is used to remove all punctuation
    marks from a string. Spaces do not count as punctuation and should
    not be removed. The funcion takes a string and returns a new string
    which does not contain any puctuation. For example:

    >>> remove_punct("Hello, World!")
    'Hello World'
    >>> remove_punct("-- ...Hey! -- Yes?!...")
    ' Hey  Yes'
    >>> remove_punct(",go!So.?uTh")
    'goSouTh'
    """
    no_punct = ""
    for char in text:
        if char not in string.punctuation:
            # If character is not a punctuation character,
            # add it to the new string.
            no_punct = no_punct + char

    return no_punct


def normalise_input(user_input):
    """This function removes all punctuation from the string and converts it to
    lower case. It then splits the string into a list of words (also removing
    any extra spaces between words) and further removes all "unimportant"
    words from the list of words using the filter_words() function. The
    resulting list of "important" words is returned. For example:

    >>> normalise_input("  Go   south! ")
    ['go', 'south']
    >>> normalise_input("!!!  tAkE,.    LAmp!?! ")
    ['take', 'lamp']
    >>> normalise_input("HELP!!!!!!!")
    ['help']
    >>> normalise_input("Now, drop the sword please.")
    ['drop', 'sword']
    >>> normalise_input("Kill ~ tHe :-  gObLiN,. wiTH my SWORD!!!")
    ['kill', 'goblin', 'sword']
    >>> normalise_input("I would like to drop my laptop here.")
    ['drop', 'laptop']
    >>> normalise_input("I wish to take this large gem now!")
    ['take', 'gem']
    >>> normalise_input("How about I go through that little passage to the south...")
    ['go', 'passage', 'south']

    """
    # Remove punctuation and convert to lower case
    no_punct = remove_punct(user_input).lower()

    # Split the string into words
    words = no_punct.split()

    # Format the words
    words = list(map(remove_punct, words))

    # Filter out the unimportant words
    important_words = filter_words(words, skip_words)

    return important_words
