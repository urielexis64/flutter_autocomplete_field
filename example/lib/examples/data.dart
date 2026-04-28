class Movie {
  const Movie(this.title, this.year);

  final String title;
  final int year;
}

const topFilms = <Movie>[
  Movie('The Shawshank Redemption', 1994),
  Movie('The Godfather', 1972),
  Movie('The Godfather: Part II', 1974),
  Movie('The Dark Knight', 2008),
  Movie('12 Angry Men', 1957),
  Movie("Schindler's List", 1993),
  Movie('Pulp Fiction', 1994),
  Movie('The Lord of the Rings: The Return of the King', 2003),
  Movie('The Good, the Bad and the Ugly', 1966),
  Movie('Forrest Gump', 1994),
  Movie('Fight Club', 1999),
  Movie('Inception', 2010),
  Movie('The Matrix', 1999),
  Movie('Goodfellas', 1990),
  Movie("One Flew Over the Cuckoo's Nest", 1975),
  Movie('Se7en', 1995),
  Movie('Interstellar', 2014),
  Movie('Spirited Away', 2001),
  Movie('Saving Private Ryan', 1998),
  Movie('The Green Mile', 1999),
];

const duplicateFilms = <Movie>[
  Movie('The Godfather', 1972),
  Movie('The Godfather', 1974),
  Movie('The Matrix', 1999),
];

const timeSlots = <String>[
  '08:00',
  '09:00',
  '10:00',
  '11:00',
  '12:00',
  '13:00',
  '14:00',
  '15:00',
];

final filmTitles = topFilms.map((movie) => movie.title).toList();
