part of '../../pluto_grid.dart';

class PlutoLeftFrozenRows extends _PlutoStatefulWidget {
  final PlutoStateManager stateManager;

  PlutoLeftFrozenRows(this.stateManager);

  @override
  _PlutoLeftFrozenRowsState createState() => _PlutoLeftFrozenRowsState();
}

abstract class _PlutoLeftFrozenRowsStateWithState
    extends _PlutoStateWithChange<PlutoLeftFrozenRows> {
  List<PlutoColumn> columns;

  List<PlutoRow> rows;

  @override
  void onChange() {
    resetState((update) {
      columns = update<List<PlutoColumn>>(
        columns,
        widget.stateManager.leftFrozenColumns,
        compare: listEquals,
      );

      rows = update<List<PlutoRow>>(
        rows,
        widget.stateManager._rows,
        compare: listEquals,
        destructureList: true,
      );
    });
  }
}

class _PlutoLeftFrozenRowsState extends _PlutoLeftFrozenRowsStateWithState {
  ScrollController scroll;

  @override
  void dispose() {
    scroll.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    scroll = widget.stateManager.scroll.vertical.addAndGet();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scroll,
      scrollDirection: Axis.vertical,
      itemCount: rows.length,
      itemExtent: widget.stateManager.rowTotalHeight,
      itemBuilder: (ctx, i) {
        return PlutoBaseRow(
          key: ValueKey('left_frozen_row_${rows[i]._key}'),
          stateManager: widget.stateManager,
          rowIdx: i,
          row: rows[i],
          columns: columns,
        );
      },
    );
  }
}
