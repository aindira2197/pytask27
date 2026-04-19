class LargeFileReader:
    def __init__(self, filename, chunk_size):
        self.filename = filename
        self.chunk_size = chunk_size
        self.file = open(filename, 'r')

    def read_chunk(self):
        return self.file.read(self.chunk_size)

    def close_file(self):
        self.file.close()

    def read_all_chunks(self):
        chunks = []
        while True:
            chunk = self.read_chunk()
            if not chunk:
                break
            chunks.append(chunk)
        return chunks

class ChunkProcessor:
    def __init__(self, chunk):
        self.chunk = chunk

    def process_chunk(self):
        processed_chunk = self.chunk.upper()
        return processed_chunk

class LargeFileProcessor:
    def __init__(self, filename, chunk_size):
        self.reader = LargeFileReader(filename, chunk_size)
        self.processed_chunks = []

    def process_file(self):
        chunks = self.reader.read_all_chunks()
        for chunk in chunks:
            processor = ChunkProcessor(chunk)
            processed_chunk = processor.process_chunk()
            self.processed_chunks.append(processed_chunk)
        self.reader.close_file()

    def get_processed_chunks(self):
        return self.processed_chunks

def main():
    filename = 'large_file.txt'
    chunk_size = 1024
    processor = LargeFileProcessor(filename, chunk_size)
    processor.process_file()
    processed_chunks = processor.get_processed_chunks()
    for i, chunk in enumerate(processed_chunks):
        print(f'Chunk {i+1}: {chunk}')

if __name__ == '__main__':
    main()