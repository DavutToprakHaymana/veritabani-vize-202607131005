CREATE TABLE qa_clean (
    id                text,
    question          text,
    answer            text,
    source_section    text,
    topic             text,
    question_length   integer,
    answer_length     integer,
    question_words    integer,
    answer_words      integer,
    paraphrase_count  integer,
    is_empty_question boolean,
    is_empty_answer   boolean
);
