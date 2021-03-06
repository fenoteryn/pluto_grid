part of '../../../pluto_grid.dart';

class PlutoSelectCell extends StatefulWidget
    implements _AbstractMixinPopupCell {
  final PlutoStateManager stateManager;
  final PlutoCell cell;
  final PlutoColumn column;

  PlutoSelectCell({
    this.stateManager,
    this.cell,
    this.column,
  });

  @override
  _PlutoSelectCellState createState() => _PlutoSelectCellState();
}

class _PlutoSelectCellState extends State<PlutoSelectCell>
    with _MixinPopupCell<PlutoSelectCell> {
  List<PlutoColumn> popupColumns;

  List<PlutoRow> popupRows;

  Icon icon = const Icon(
    Icons.arrow_drop_down,
  );

  @override
  void initState() {
    super.initState();

    popupHeight = ((widget.column.type.select.items.length + 1) *
            widget.stateManager.rowTotalHeight) +
        PlutoGridSettings.shadowLineSize +
        PlutoGridSettings.gridInnerSpacing;

    fieldOnSelected = widget.column.title;

    popupColumns = [
      PlutoColumn(
        title: widget.column.title,
        field: widget.column.title,
        type: PlutoColumnType.text(readOnly: true),
        formatter: widget.column.formatter,
      )
    ];

    popupRows = widget.column.type.select.items.map((dynamic item) {
      return PlutoRow(
        cells: {
          widget.column.title: PlutoCell(value: item),
        },
      );
    }).toList();
  }

  @override
  void _onLoaded(PlutoOnLoadedEvent event) {
    event.stateManager.setSelectingMode(PlutoSelectingMode.none);

    super._onLoaded(event);
  }
}
