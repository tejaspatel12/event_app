import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import '../../model/event_model.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  _EventDetailScreenState createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _areButtonsVisible = true;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      setState(() {
        _areButtonsVisible = _shouldShowButtons();
      });
    });
  }

  bool _shouldShowButtons() {
    // Calculate the scroll position where you want to hide the buttons.
    // You can adjust this value to match your layout.
    final scrollPositionToShowButtons = 300.0; // Adjust as needed

    // Determine whether the buttons should be visible or not based on the scroll position.
    return _scrollController.offset < scrollPositionToShowButtons;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(widget.event.title),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController, // Attach the scroll controller to the SingleChildScrollView
            // padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(widget.event.imageUrl),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.event.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2,),

                              Text(
                                widget.event.location, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),

                              SizedBox(height: 2,),

                              Text(
                                '${widget.event.eventTime}',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 2,),
                            ],
                          ),
                        ),

                      ],
                    )
                ),
                Divider(height: 1),

                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Decor Price',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            '\₹${widget.event.price.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                ),

                const SizedBox(height: 10,),

                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Priceing Info',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Indoor Budget',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '\₹${widget.event.price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),


                          SizedBox(height: 6,),
                          const DottedLine(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            lineLength: double.infinity,
                            lineThickness: 0.5,
                            dashLength: 8.0,
                            dashColor: Colors.black54,
                          ),
                          SizedBox(height: 6,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Indoor Budget',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '\₹${widget.event.price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),


                          SizedBox(height: 6,),
                          const DottedLine(
                            direction: Axis.horizontal,
                            alignment: WrapAlignment.center,
                            lineLength: double.infinity,
                            lineThickness: 0.5,
                            dashLength: 8.0,
                            dashColor: Colors.black54,
                          ),
                          SizedBox(height: 6,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Indoor Budget',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                              Text(
                                '\₹${widget.event.price.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),

                        ],
                      ),
                    )
                ),

                const SizedBox(height: 10,),

                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Albums',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),

                          Row(
                            children: [
                              Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network(widget.event.imageUrl)),
                                  )),

                              Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(borderRadius: BorderRadius.circular(10),child: Image.network(widget.event.imageUrl)),
                                  )),
                            ],
                          ),

                        ],
                      ),
                    )
                ),

                const SizedBox(height: 10,),

                //ABOUT
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            widget.event.description,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),

                        ],
                      ),
                    )
                ),
                const SizedBox(height: 10,),

                //REVIEW
                Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Review',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            widget.event.description,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),

                        ],
                      ),
                    )
                ),
                const SizedBox(height: 100,),


                // You can add more event details here
              ],
            ),
          ),

          // "Message" and "Call" buttons
          Visibility(
            visible: _areButtonsVisible,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                color: Colors.white, // Background color for the buttons
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Handle Message button tap
                    //   },
                    //   child: const Text('Message'),
                    // ),

                    Flexible(
                      flex: 3,
                      child: GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.message,color: Colors.red,),
                                SizedBox(width: 5,),
                                Text("Message",style: TextStyle(color: Colors.red),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.call,color: Colors.white,),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



