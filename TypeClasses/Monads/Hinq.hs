module Main where
{-
Implementation of SQL-like quries on student database
-}


data Name = Name {
    firstName :: String,
    lastName :: String
}

instance Show Name where
    show (Name first last) = first ++ " " ++ last

data GradeLevel = Freshman | Junior | Sophmore deriving (Eq,Ord,Enum,Show)

data Student = Student {
    studentId :: Int,
    gradeLevel :: GradeLevel,
    studentName :: Name
} deriving Show

data Teacher = Teacher {
    teacherId :: Int,
    teacherName :: Name
} deriving (Show)

data Course = Course {
    courseId :: Int,
    courseTitle :: String,
    teacher :: Int
} deriving (Show)

createStudents :: [Student]
createStudents = [
    (Student 1 Freshman (Name "tushar" "adhatrao")),
    (Student 2 Junior (Name "Nehal" "adhatrao")),
    (Student 3 Sophmore (Name "Paras" "adhatrao")),
    (Student 4 Freshman (Name "Deepak" "Jha")),
    (Student 5 Freshman (Name "Prasad" "adhatrao")) ]

createTeachers :: [Teacher]
createTeachers = [
    (Teacher 1 (Name "Ganesh" "Khupkar")),
    (Teacher 2 (Name "Manish" "P")),
    (Teacher 3 (Name "Vikas" "Gadekar"))
    ]

createCourse :: [Course]
createCourse = [
        (Course 1 "Data structures" 1),
        (Course 2 "Computer Networks" 2),
        (Course 3 "Operating System" 3)
    ]

selectQ :: (a -> b) -> [a] -> [b]
selectQ name lst = map name lst

whereQ :: (a -> Bool) -> [a] -> [a]
whereQ condition lst = filter condition lst

startsWith :: Char -> String -> Bool
startsWith ch str = ch == (head str)

joinQ :: (Eq c) => [a] -> [b] -> (a -> c) -> (b -> c) -> [(a,b)]
joinQ lst1 lst2 prop1 prop2 = filter (\(x,y) -> (prop1 x == prop2 y)) [(x,y) | x <- lst1 , y <- lst2]

main :: IO ()
main = do
    print $ map studentName createStudents
    print $ selectQ studentName createStudents
    print $ selectQ (lastName.studentName) createStudents
    print $ selectQ gradeLevel createStudents
    print $ selectQ (\x -> (studentId x,studentName x)) createStudents
    print $ whereQ (=="Jha") $ selectQ (lastName.studentName) createStudents
    print $ whereQ (startsWith 'a' .lastName) $ selectQ (studentName) createStudents
    print $ joinQ createTeachers createCourse teacherId teacher
