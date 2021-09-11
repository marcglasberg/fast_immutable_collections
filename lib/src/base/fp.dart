typedef Predicate<T> = bool Function(T element);

/// Operation of type that conserve the original type
typedef Op<T> = T Function(T element);

typedef EQ<T, U> = bool Function(T item, U other);
