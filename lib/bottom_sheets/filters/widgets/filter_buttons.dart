// ignore_for_file: library_private_types_in_public_api
part of '../filter_sheet.dart';

Widget _clearFilterButton(
    {required _FilterState state, required WidgetRef ref}) {
  final ThemeManager themeManager =
      ref.read(ProviderList.themeProvider).themeManager;
  return GestureDetector(
    onTap: () {
      state.filters = Filters(
        priorities: [],
        states: [],
        assignees: [],
        createdBy: [],
        labels: [],
        targetDate: [],
        startDate: [],
        stateGroup: [],
        subscriber: [],
      );
      state._applyFilters(ref.context);
    },
    child: Container(
        height: 35,
        width: 150,
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 2),
        margin: const EdgeInsets.only(bottom: 20, top: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: themeManager.borderSubtle01Color,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              'Clear all Filters',
              type: FontStyle.Medium,
              color: themeManager.placeholderTextColor,
            ),
          ],
        )),
  );
}

Widget _saveView({required _FilterState state, required WidgetRef ref}) {
  final themeProvider = ref.read(ProviderList.themeProvider);
  return InkWell(
    onTap: state.isFilterEmpty()
        ? null
        : () {
            Navigator.of(ref.context).push(MaterialPageRoute(
                builder: (context) => CreateView(
                      filtersData: state.filters,
                      fromProjectIssues: true,
                    )));
          },
    child: Container(
        width: MediaQuery.of(ref.context).size.width * 0.42,
        height: 50,
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: state.isFilterEmpty()
              ? themeProvider.themeManager.borderSubtle01Color.withOpacity(0.6)
              : themeProvider.themeManager.primaryColour.withOpacity(0.2),
          border: Border.all(
              color: state.isFilterEmpty()
                  ? themeProvider.themeManager.placeholderTextColor
                  : themeProvider.themeManager.primaryColour),
          borderRadius: BorderRadius.circular(buttonBorderRadiusLarge),
        ),
        child: Center(
          child: Wrap(
            children: [
              Icon(
                Icons.add,
                color: state.isFilterEmpty()
                    ? themeProvider.themeManager.placeholderTextColor
                    : themeProvider.themeManager.primaryColour,
                size: 24,
              ),
              CustomText(
                '  Save View',
                color: state.isFilterEmpty()
                    ? themeProvider.themeManager.placeholderTextColor
                    : themeProvider.themeManager.primaryColour,
                fontWeight: FontWeightt.Semibold,
                type: FontStyle.Medium,
              ),
            ],
          ),
        )),
  );
}

Widget _applyFilterButton({
  required _FilterState state,
  required BuildContext context,
}) {
  return Container(
    height: 50,
    width: state.fromCreateView || state.issueCategory == IssueCategory.myIssues
        ? MediaQuery.of(context).size.width * 0.87
        : MediaQuery.of(context).size.width * 0.42,
    margin: const EdgeInsets.only(bottom: 18),
    child: Button(
      text: state.fromCreateView ? 'Add Filter' : 'Apply Filter',
      ontap: () {
        state._applyFilters(context);
      },
      textColor: Colors.white,
    ),
  );
}
