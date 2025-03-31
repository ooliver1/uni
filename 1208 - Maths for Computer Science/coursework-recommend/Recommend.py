import itertools
import math
import pathlib

path = pathlib.Path(__file__).parent.resolve()


def main():
    n_customers: int
    n_items: int
    n_transactions: int
    history: list[tuple[int, int]]
    queries: list[list[int]]

    with open(path / "history.txt", "r") as f:
        lines = f.readlines()
        n_customers, n_items, n_transactions = map(int, lines[0].split())
        history = [(int(line.split()[0]), int(line.split()[1])) for line in lines[1:]]

    with open(path / "queries.txt", "r") as f:
        queries = [list(map(int, line.split())) for line in f.readlines()]

    customer_vectors: dict[int, list[int]] = {}

    for customer_id in range(1, n_customers + 1):
        customer_vectors[customer_id] = [0] * n_items

    for customer_id, item_id in history:
        customer_vectors[customer_id][item_id - 1] = 1

    positive_entries = 0
    for vector in customer_vectors.values():
        positive_entries += sum(vector)

    print(f"Positive entries: {positive_entries}")

    item_vectors: dict[int, list[int]] = {}
    for item_id in range(1, n_items + 1):
        item_vectors[item_id] = [0] * n_customers

    for customer_id, item_id in history:
        item_vectors[item_id][customer_id - 1] = 1

    item_to_item_angles: dict[int, dict[int, float]] = {}

    for item_id in range(1, n_items + 1):
        item_to_item_angles[item_id] = {}

    for item_1, item_2 in itertools.combinations(range(1, n_items + 1), 2):
        vector_1 = item_vectors[item_1]
        vector_2 = item_vectors[item_2]

        dot_product = sum(a * b for a, b in zip(vector_1, vector_2))

        norm_1 = sum(a * a for a in vector_1) ** 0.5
        norm_2 = sum(a * a for a in vector_2) ** 0.5
        angle = math.acos(dot_product / (norm_1 * norm_2))
        angle_degrees = math.degrees(angle)

        item_to_item_angles[item_1][item_2] = angle_degrees
        item_to_item_angles[item_2][item_1] = angle_degrees

    # average_angle = average(
    #     [angle for angles in item_to_item_angles.values() for angle in angles.values()]
    # )
    average_angle = sum(
        angle for angles in item_to_item_angles.values() for angle in angles.values()
    ) / len(item_to_item_angles)
    print(f"Average angle: {average_angle:.2f}")

    for query in queries:
        print(f"Shopping cart: {' '.join(map(str, query))}")

        matches: list[tuple[int, float]] = []
        for item in query:
            angles = sorted(
                item_to_item_angles[item].items(),
                key=lambda x: x[1],
            )

            top_match = 0
            for match, angle in angles:
                if match not in query:
                    top_match = match
                    break

            if top_match:
                print(f"Item: {item}; match: {top_match}; angle: {angle:.2f}")
                matches.append((top_match, angle))
            else:
                print(f"Item: {item}; no match")

        matches.sort(key=lambda x: x[1])

        recommendations = []
        for match, _ in matches:
            if match not in query and match not in recommendations:
                recommendations.append(match)

        print(f"Recommend: {' '.join(map(str, recommendations))}")


if __name__ == "__main__":
    main()
