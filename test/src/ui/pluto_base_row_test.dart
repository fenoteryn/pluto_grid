import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../helper/column_helper.dart';
import '../../helper/pluto_widget_test_helper.dart';
import '../../helper/row_helper.dart';
import '../../mock/mock_pluto_state_manager.dart';

void main() {
  PlutoStateManager stateManager;
  List<PlutoColumn> columns;
  List<PlutoRow> rows;

  setUp(() {
    stateManager = MockPlutoStateManager();
    when(stateManager.configuration).thenReturn(PlutoConfiguration());
    when(stateManager.localeText).thenReturn(const PlutoGridLocaleText());
  });

  final buildRowWidget = ({
    int rowIdx = 0,
    bool checked = false,
    bool isDragTarget = false,
    bool isTopDragTarget = false,
    bool isBottomDragTarget = false,
    bool isSelectedRow = false,
    bool isCurrentCell = false,
    bool isSelectedCell = false,
  }) {
    return PlutoWidgetTestHelper(
      'build row widget.',
      (tester) async {
        when(stateManager.isRowIdxDragTarget(any)).thenReturn(isDragTarget);
        when(stateManager.isRowIdxTopDragTarget(any))
            .thenReturn(isTopDragTarget);
        when(stateManager.isRowIdxBottomDragTarget(any))
            .thenReturn(isBottomDragTarget);
        when(stateManager.isSelectedRow(any)).thenReturn(isSelectedRow);
        when(stateManager.isCurrentCell(any)).thenReturn(isCurrentCell);
        when(stateManager.isSelectedCell(any, any, any))
            .thenReturn(isSelectedCell);

        // given
        columns = ColumnHelper.textColumn('header', count: 3);
        rows = RowHelper.count(10, columns);

        final row = rows[rowIdx];

        if (checked) {
          row.setChecked(true);
        }

        // when
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: PlutoBaseRow(
                stateManager: stateManager,
                rowIdx: rowIdx,
                row: row,
                columns: columns,
              ),
            ),
          ),
        );
      },
    );
  };

  buildRowWidget(checked: true).test(
    'row 가 checked 가 true 일 때, rowColor 에 alphaBlend 가 적용 되어야 한다.',
    (tester) async {
      final rowContainerWidget =
          find.byType(Container).first.evaluate().first.widget as Container;

      final rowContainerDecoration =
          rowContainerWidget.decoration as BoxDecoration;

      expect(
        rowContainerDecoration.color,
        Color.alphaBlend(const Color(0x11757575), Colors.transparent),
      );
    },
  );

  buildRowWidget(checked: false).test(
    'row 가 checked 가 false 일 때, rowColor 에 alphaBlend 가 적용 되지 않아야 한다.',
    (tester) async {
      final rowContainerWidget =
          find.byType(Container).first.evaluate().first.widget as Container;

      final rowContainerDecoration =
          rowContainerWidget.decoration as BoxDecoration;

      expect(rowContainerDecoration.color, Colors.transparent);
    },
  );

  buildRowWidget(
    isDragTarget: true,
    isTopDragTarget: true,
  ).test(
    'isDragTarget, isTopDragTarget 이 true 인 경우 border top 이 설정 되어야 한다.',
    (tester) async {
      final rowContainerWidget =
          find.byType(Container).first.evaluate().first.widget as Container;

      final rowContainerDecoration =
          rowContainerWidget.decoration as BoxDecoration;

      expect(
        rowContainerDecoration.border.top.width,
        PlutoGridSettings.rowBorderWidth,
      );
    },
  );

  buildRowWidget(
    isDragTarget: true,
    isBottomDragTarget: true,
  ).test(
    'isDragTarget, isBottomDragTarget 이 true 인 경우 border bottom 이 설정 되어야 한다.',
    (tester) async {
      final rowContainerWidget =
          find.byType(Container).first.evaluate().first.widget as Container;

      final rowContainerDecoration =
          rowContainerWidget.decoration as BoxDecoration;

      expect(
        rowContainerDecoration.border.bottom.width,
        PlutoGridSettings.rowBorderWidth,
      );
    },
  );
}
