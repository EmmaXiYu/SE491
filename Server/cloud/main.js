Parse.Cloud.afterSave("Bid", function(request) {
    afterSaveBid(request.object); 
});

Parse.Cloud.afterSave("Spot", function(request){
    afterSaveSpot(request.object);
    
});

function afterSaveBid(bid){
    var currentStatus = bid.get("StatusId");
    var oldStatus = bid.get("StatusId");
    if(currentStatus == 4 && oldStatus == 2){
        BidCancelAfterAccept(bid);
    }else if(currentStatus == 2){
        BidAccept(bid);
    }else if(currentStatus == 1){
        var spot = bid.get("spot")
        console.log(spot.id);
        var query = new Parse.Query("Spot");
        query.equalTo("objectId",  spot.id)
        query.find({
            success: function(results) {
                for(var i = 0; i < results.length; i++){
                    console.log("bid length" + results.length);
                    var pushQuery = new Parse.Query(Parse.Installation);
                    console.log(results[i].get("user"));
                    pushQuery.equalTo("user", results[i].get("owner"));
                    Parse.Push.send({
                        where: pushQuery, // Set our Installation query
                        data: {
                            "alert" : "You spot got a bid. Check Detail." ,
                            "badge" : "Increment",
                            "sound" : "iphonenoti_cRjTITC7.mp3",         
                        }
                    }, {
                        success: function() {
                            console.log("Push notification sucessful");
                        },
                        error: function(error) {
                            console.log("ERROR" + error.code + " " + error.message);
                        }
                    });
                }
            }, 
            error: function(error){
                console.log("ERROR" + error.code + " " + error.message);
            }
        });//find
        console.log(status);
    }else if(currentStatus == 5){
        var spot = bid.get("spot")
        console.log(spot.id);
        var query = new Parse.Query("Bid");
        query.equalTo("spot",  spot)
        query.find({
            success: function(results) {
                for(var i = 0; i < results.length; i++){
                    console.log("bid length" + results.length);
                    var pushQuery = new Parse.Query(Parse.Installation);
                    console.log(results[i].get("user"));
                    pushQuery.equalTo("user", results[i].get("user"));
                    Parse.Push.send({
                        where: pushQuery, // Set our Installation query
                        data: {
                            "alert" : "You bid is rejected. Start a new bid." ,
                            "badge" : "Increment",
                            "sound" : "iphonenoti_cRjTITC7.mp3",         
                        }
                    }, {
                        success: function() {
                            console.log("Push notification sucessful");
                        },
                        error: function(error) {
                            console.log("ERROR" + error.code + " " + error.message);
                        }
                    });
                }
            }, 
            error: function(error){
                console.log("ERROR" + error.code + " " + error.message);
            }
        });//find
        console.log(status);
    }
}

function afterSaveSpot(spot){
    var status = spot.get("StatusId");
    if(status == 4){
        SpotCancel(spot);
    }
}

function BidAccept(bid){
    query = new Parse.Query("Bid");
    query.equalTo("spot", bid.get("spot"));
    query.equalTo("StatusId", 1);
    query.find({
        success: function(results) {
            for(var i = 0; i < results.length; i++){
                results[i].set("StatusId", 5);
                results[i].save();
            }
        }, error: function(error){
            console.log("ERROR" + error.code + " " + error.message);
        }
    });
    var pushQuery = new Parse.Query(Parse.Installation);
    pushQuery.equalTo("user", bid.get("user"));
    Parse.Push.send({
        where: pushQuery, // Set our Installation query
        data: {
            "alert" : "You bid is accepted. Check the detail and pay." ,
            "badge" : "Increment",
            "sound" : "iphonenoti_cRjTITC7.mp3",         
        }
    }, {
        success: function() {
            console.log("Push notification sucessful");
        },
        error: function(error) {
            console.log("ERROR" + error.code + " " + error.message);
        }
    });
    console.log(status);
}

Parse.Cloud.job("TimeUp", function SpotTimeUp(resquest, response){
    var query = new Parse.Query("Spot");
    query.equalTo("StatusId", 1);
    query.lessThan("leavingTime", new Date());
    query.find({
        sucess: function(results) {
            for(var i = 0; i < results.length; i++){
                SpotHasBids(results[i]);
            }
        },
        error: function(error) {
            console.log(error);
        }
    });
});

function SpotHasBid(spot){
    var query = new Parse.Query("Bid");
    query.equalTo("spot", spot);
    query.find({
        success: function(results) {
            if(results.length == 0){
                spot.set("StatusId", 6);
            }else{
                spot.set("StatusId", 7);
                for(var i = 0; i < results.length; i++){
                    var status = results[i].get("StatusId");
                    if(status == 2){
                        results[i].set("StatusId", 6);
                        results[i].save();
                    }else if(status == 1){
                        results[i].set("StatusId", 7);
                        results[i].save();
                    }
                }
            }            
            spot.save();
        },
        error: function(error) {
            console.log(error);
        }
    });
}


function SpotCancel(spot){
    var query = new Parse.Query("Bid");
    query.equalTo("spot", spot);
    query.find({
        success: function(results) {
            for(var i = 0; i < results.length; i++){
                var status = results[i].get("StatusId");
                if(status == 1 || status == 2){
                    results[i].set("StatusId", 4);
                    results[i].save();
                }
            }
        },
        error: function(error) {
            console.log(error);
        }
    });
    console.log(spot);
    var query = new Parse.Query("Bid");
    var spot = request.object
    query.equalTo("spot",  spot)
    query.find({
        success: function(results) {
            for(var i = 0; i < results.length; i++){
                var userQuery = new Parse.Query(Parse.User)
                userQuery.equalTo("objectId", results[i].get("user"))
                userQuery.find({
                    success: function(userResults){
                        for(var i = 0; i < results.length; i++){
                            var pushQuery = new Parse.Query(Parse.Installation);
                            pushQuery.equalTo("user", userResults[i])
                            Parse.Push.send({
                                where: pushQuery, // Set our Installation query
                                data: {
                                    "alert" : "The spot u bid was cancelled. Find other spot" ,
                                    "badge" : "Increment",
                                    "sound" : "iphonenoti_cRjTITC7.mp3",         
                                }
                            }, {
                                success: function() {
                                    console.log("Push notification sucessful");
                                },
                                error: function(error) {
                                    console.log("ERROR" + error.code + " " + error.message);
                                }
                            });
                        }
                    }, 
                    error: function(error){
                        console.log("ERROR" + error.code + " " + error.message);
                    }
                });//find
            }
        }, error: function(error){
            console.log("ERROR" + error.code + " " + error.message);
        }
    });
    console.log(status);
}

function BidCancelAfterAccept(bid){
    var query = query = Parse.Query("Bid");
    query.equalTo("spot", bid.get("spot"));
    query.find({
        success: function(results){
            for(var i = 0; i < results.length; i++){
                var status = results.get("StatusId");
                if(status == 5){
                    results[i].set("StatusId", 1);
                    results.save();
                }
            }
        }
    });
    var spot = bid.get("spot");
    console.log(spot.id);
    var query = new Parse.Query("Spot");
    query.equalTo("objectId",  spot.id);
    query.find({
        success: function(results) {
            for(var i = 0; i < results.length; i++){
                console.log("bid length" + results.length);
                var pushQuery = new Parse.Query(Parse.Installation);
                console.log(results[i].get("owner").id);
                pushQuery.equalTo("user", results[i].get("owner"));
                Parse.Push.send({
                    where: pushQuery, // Set our Installation query
                    data: {
                        "alert" : "You accepted bid was cancelled. Please choose another bid." ,
                        "badge" : "Increment",
                        "sound" : "iphonenoti_cRjTITC7.mp3",         
                    }
                }, {
                    success: function() {
                        console.log("Accepted bid was cancelled-Push notification sucessful");
                    },
                    error: function(error) {
                        console.log("ERROR" + error.code + " " + error.message);
                    }
                });
            }
        }, 
        error: function(error){
            console.log("ERROR" + error.code + " " + error.message);
        }
    }); 
    console.log(status);
}

Parse.Cloud.job("UpdateSpotOnExpireJob", function(request, response) {
                var usersToSave= [];
                var query = new Parse.Query("Spot");
                var d = new Date();
                var twoDay = (2 * 24 * 3600 * 1000);
                var ThirtyDay = (30 * 24 * 3600 * 1000);
                
                var twoDayBackDate = new Date(d.getTime() - (twoDay));
                var ThirtyDayBackDate = new Date(d.getTime() - (ThirtyDay));
                
                // Query Expiration
                var d = new Date();
                var todaysDate = new Date(d.getTime());
                query.greaterThanOrEqualTo('createdAt', ThirtyDayBackDate);
                query.lessThan('createdAt', twoDayBackDate);
               
                //Find all the spot in last 30 days , but at least two days old
                query.find().then(function(results) {
                  for(var i = 0; i < results.length; i++)
                        {
                        var user = results[i];
                                  if( user.get("StatusId")== undefined || user.get("StatusId")== 0 || user.get("StatusId") == "undefined" )
                                {
                                  // StatusId")== undefined means no bid has been made on this spot
                                    user.set("StatusId", 6); // Status 6 means Expired with no bid
                                    //user.set("owner", user.set("StatusId");
                                    usersToSave.push(user);
                                  }
                        }

                        }).then(function()
                            {
                                        Parse.Object.saveAll(usersToSave, {
                                            success: function(list) {
                                            // All the objects were saved.
                                            //if (status) {
                                            //status.success("Update completed successfully.");
                                              //  };
                                            console.log("saveInBackground success");
                                            },
                                            error: function(model, error) {
                                             console.log("saveInBackground Error");                 
                                            //if (error) {
                                              //  status.error(error);
                                            //};
                                }})
                    })

        });

Parse.Cloud.define("UpdateSpotOnExpireIsDefination_NotAJob", function(request, response) {
                   
                   query.find().then(function(results) {
                                     for(var i = 0; i < results.length; i++)
                                     {
                                     var user = results[i];
                                     user.set("minimumPrice", 1.98);
                                     usersToSave.push(user);
                                     }
                                     
                                     }).then(function()
                                             {
                                             Parse.Object.saveAll(usersToSave, {
                                                                  success: function(list) {
                                                                  // All the objects were saved.
                                                                  if (status) {
                                                                  status.success("Update completed successfully.");
                                                                  };
                                                                  console.log("saveInBackground success");
                                                                  },
                                                                  error: function(model, error) {
                                                                  if (error) {
                                                                  status.error(error);
                                                                  };
                                                                  }})
                                             })
                   });

