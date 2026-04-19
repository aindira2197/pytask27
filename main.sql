CREATE TABLE large_files (
    id INT PRIMARY KEY,
    file_name VARCHAR(255),
    file_size INT,
    chunk_size INT,
    chunks INT,
    chunk_index INT
);

CREATE TABLE chunks (
    id INT PRIMARY KEY,
    file_id INT,
    chunk_data BLOB,
    chunk_index INT,
    FOREIGN KEY (file_id) REFERENCES large_files(id)
);

CREATE PROCEDURE split_file_into_chunks(
    file_name VARCHAR(255),
    file_size INT,
    chunk_size INT
)
BEGIN
    DECLARE chunk_index INT;
    DECLARE chunk_data BLOB;
    SET chunk_index = 1;
    WHILE chunk_index * chunk_size < file_size DO
        SET chunk_data = SUBSTR(file_name, (chunk_index - 1) * chunk_size + 1, chunk_size);
        INSERT INTO chunks (file_id, chunk_data, chunk_index) VALUES (1, chunk_data, chunk_index);
        SET chunk_index = chunk_index + 1;
    END WHILE;
END;

CREATE PROCEDURE read_chunks(
    file_id INT
)
BEGIN
    DECLARE chunk_index INT;
    DECLARE chunk_data BLOB;
    SET chunk_index = 1;
    WHILE chunk_index <= (SELECT chunks FROM large_files WHERE id = file_id) DO
        SET chunk_data = (SELECT chunk_data FROM chunks WHERE file_id = file_id AND chunk_index = chunk_index);
        SELECT chunk_data;
        SET chunk_index = chunk_index + 1;
    END WHILE;
END;

INSERT INTO large_files (id, file_name, file_size, chunk_size, chunks) VALUES (1, 'large_file.txt', 1024, 256, 4);

CALL split_file_into_chunks('large_file.txt', 1024, 256);

CALL read_chunks(1); 

CREATE INDEX idx_large_files_id ON large_files(id);
CREATE INDEX idx_chunks_file_id ON chunks(file_id);
CREATE INDEX idx_chunks_chunk_index ON chunks(chunk_index);

OPTIMIZE TABLE large_files;
OPTIMIZE TABLE chunks; 

ALTER TABLE large_files ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE chunks ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

UPDATE large_files SET created_at = CURRENT_TIMESTAMP WHERE id = 1;
UPDATE chunks SET created_at = CURRENT_TIMESTAMP WHERE file_id = 1; 

SELECT * FROM large_files WHERE id = 1;
SELECT * FROM chunks WHERE file_id = 1; 

CREATE VIEW large_files_view AS SELECT * FROM large_files;
CREATE VIEW chunks_view AS SELECT * FROM chunks;

SELECT * FROM large_files_view WHERE id = 1;
SELECT * FROM chunks_view WHERE file_id = 1; 

DROP PROCEDURE split_file_into_chunks;
DROP PROCEDURE read_chunks;
DROP TABLE large_files;
DROP TABLE chunks; 
DROP INDEX idx_large_files_id ON large_files;
DROP INDEX idx_chunks_file_id ON chunks;
DROP INDEX idx_chunks_chunk_index ON chunks; 
DROP VIEW large_files_view;
DROP VIEW chunks_view;