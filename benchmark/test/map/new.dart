class StudentsPerCourse {
  final IMapOfSets<Course, Student> imap;

  StudentsPerCourse([Map<Course, Set<Student>> studentsPerCourse])
      : _studentsPerCourse = (studentsPerCourse ?? {}).lock;

  StudentsPerCourse._(this._studentsPerCourse);

  ISet<Course> courses() => imap.keysAsSet;

  ISet<Student> students() => imap.valuesAsSet;

  IMapOfSets<Student, Course> getCoursesPerStudent() => imap.invertKeysAndValues();

  ISet<Student> studentsInAlphabeticOrder() =>
      imap.valuesAsSet.toIList(compare: (s1, s2) => s1.name.compareTo(s2.name));

  ISet<String> studentNamesInAlphabeticOrder() => imap.valuesAsSet.map((s) => s.name).toIList();

  StudentsPerCourse addStudentToCourse(Student student, Course course) =>
      StudentsPerCourse._(imap.add(course, student));

  StudentsPerCourse addStudentToCourses(Student student, Iterable<Course> courses) =>
      StudentsPerCourse._(imap.addValuesToKeys(courses, [student]));

  StudentsPerCourse addStudentsToCourse(Iterable<Student> students, Course course) =>
      StudentsPerCourse._(imap.addValues(course, students));

  StudentsPerCourse addStudentsToCourses(Map<Course, Set<Student>> studentsPerCourse) =>
      StudentsPerCourse._(imap.addMap(studentsPerCourse));

  StudentsPerCourse removeStudentFromCourse(Student student, Course course) =>
      StudentsPerCourse._(imap.remove(course, student));

  StudentsPerCourse removeStudentFromAllCourses(Student student) =>
      StudentsPerCourse._(imap.removeValues([student]));

  StudentsPerCourse removeCourse(Course course) => StudentsPerCourse._(imap.removeSet(course));
  Map<Course, Set<Student>> toMap() => imap.unlock;

  int get numberOfCourses => imap.lengthOfKeys;
  
  int get numberOfStudents => imap.lengthOfNonRepeatingValues;
}
