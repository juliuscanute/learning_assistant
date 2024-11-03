import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:learning_assistant/domain/entities/event_entity.dart';
import 'package:learning_assistant/presentation/bloc/event_details.bloc.dart';

class ListItemCard extends StatefulWidget {
  final EventEntity event;
  final EventDetailsBloc eventDetailsBloc;

  const ListItemCard({
    Key? key,
    required this.event,
    required this.eventDetailsBloc,
  }) : super(key: key);

  @override
  ListItemCardState createState() => ListItemCardState();
}

class ListItemCardState extends State<ListItemCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailsBloc, EventDetailsState>(
      bloc: widget.eventDetailsBloc,
      builder: (context, state) {
        return Card(
          child: InkWell(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
                if (isExpanded) {
                  widget.eventDetailsBloc.add(
                    LoadEventDetails(
                      date: widget.event.date,
                      description: widget.event.descriptions.first.description,
                    ),
                  );
                }
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: widget.event.descriptions
                              .map((desc) => Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          desc.description,
                                          maxLines: isExpanded ? null : 4,
                                          overflow: isExpanded
                                              ? TextOverflow.visible
                                              : TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Checkbox(
                                        value: state is EventDetailsLoaded &&
                                            state.events
                                                .firstWhere((element) =>
                                                    element.date ==
                                                    widget.event.date)
                                                .descriptions
                                                .firstWhere((element) =>
                                                    element.description ==
                                                    desc.description)
                                                .isReviewed,
                                        onChanged: (value) {
                                          widget.eventDetailsBloc.add(
                                            UpdateEventReview(
                                              widget.event.date,
                                              desc.description,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                      if (isExpanded) _buildExpandedView(state),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExpandedView(EventDetailsState state) {
    if (state is EventDetailsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is EventDetailsLoaded) {
      return Column(
        children: state.events.map((element) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Text(
                  DateFormat('d MMMM y').format(element.date),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: _determineColor(element.descriptions),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } else if (state is EventDetailsError) {
      return Center(child: Text('Error: ${state.message}'));
    }
    return const SizedBox();
  }

  Color _determineColor(List<DescriptionEntity> items) {
    bool allTrue = items.every((item) => item.isReviewed);
    bool someTrue = items.any((item) => item.isReviewed);

    if (allTrue) {
      return Colors.green;
    } else if (someTrue) {
      return Colors.yellow;
    }
    return Colors.red;
  }
}
