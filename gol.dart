import 'dart:math';
import 'dart:io';

void main() {
	var board = Board(15,15);
  while (true) {
    board.nextGeneration();
    print(board.toString());
    sleep(Duration(seconds: 3));
    print('\n');
  }
}

class Cell {
	bool alive = false;

  Cell(this.alive);

  @override
  String toString() {
    return this.alive ? " . " : "   ";
  }
}

extension RangeExtension on int {
	List<int> upTo(int maxInclusive) =>
		[for (int i = this; i <= maxInclusive; i++) i];
}

class Board {
	int rowSize = 0;
	int colSize = 0;
	var rows = [];

	Board(this.rowSize, this.colSize);

	@override
	String toString() {
		String board = "";
    this.rows.forEach( (column) {
        column.forEach( (cell) {
          board += '${cell}';
        });
        board += '\n';
    });
    return board;
	}

  bool willLive(int row, int col) {
    var neighbors = getLiveNeighborsFor(row, col);
    if (tooMany(neighbors) || tooFew(neighbors)) {
      return false;
    }
    return true;
  }

  int getLiveNeighborsFor(int myRow, int myCol) {
    int live = 0;
    (myRow-1).upTo(myRow+1).forEach( (row)  {
      (myCol-1).upTo(myCol+1).forEach( (col) {
        if (myRow==row && myCol == col) {
          // don't count myself in neighbor count!
        } else if(row >= this.rowSize || col >= this.colSize || row <= 0 || col <= 0) {
          // edge detected!
        } else {
          Cell neighbor = this.rows[row][col];
          if(neighbor.alive) live++;
        }
      });
    });
    return live;
  }

  bool tooMany(int neighbors) {
    return neighbors > 3;
  }

  bool tooFew(int neighbors) {
    return neighbors < 2;
  }

	void nextGeneration() {
		final rows = [];
		0.upTo(this.rowSize-1).forEach( (row) {
      final cols = [];
			0.upTo(this.colSize-1).forEach( (col) { 
        cols.add(
          this.rows.length==0 ? 
            Cell(Random().nextBool()) :
            Cell(willLive(row, col))
        );
			});
      rows.add(cols);
		});
    this.rows = rows;
	}
}
