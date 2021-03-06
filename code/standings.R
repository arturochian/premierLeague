output$standings <- DT::renderDataTable({
 
  
  if (!is.null(input$season_4a)) {
    year <- input$season_4a
  } else {
    year <- "2014/15"
  }
  if (!is.null(input$games_4a)) {
    games <- input$games_4a
  } else {
    games <- currentRound 
  }
  
  df <-  data.frame(standings %>%
                      filter(season==year&tmYrGameOrder==games) %>%
                      select(Pos=position,Team=team,Pl=tmYrGameOrder,Pts=cumPts,GD=cumGD,GF=cumGF,Final=final_Pos))
  
  df <- df[,c(-1)]
  DT::datatable(df,options= list(paging = FALSE, searching = FALSE,info=FALSE,
                                 
                                 order=list(c(0,'asc'))))
                                
  
}
)


output$leaders <- DT::renderDataTable({
  
  
  if (!is.null(input$season_4a)) {
    year <- input$season_4a
  } else {
    year <- "2014/15"
  }
  if (!is.null(input$games_4b)) {
    games <- input$games_4b
  } else {
    games <- currentRound 
  }
  if (!is.null(input$position_4a)) {
    pos <- input$position_4a
  } else {
    pos <- 1 
  }
  
  df <-  data.frame(standings %>%
                      filter(tmYrGameOrder==games&position==pos) %>%
                      select(Season=season,Team=team,Pts=cumPts,GD=cumGD,GF=cumGF,Final=final_Pos))
  DT::datatable(df,options= list(paging = FALSE, searching = FALSE, info=FALSE,
                                 
                                 order=list(c(0,'desc'))))
  
}
)

output$teamStanding <- DT::renderDataTable({
  print(teamsChoice)
  
  if (!is.null(input$games_4a)) {
    games <- input$games_4a
  } else {
    games <- currentRound 
  }
  if (!is.null(input$team_4a)) {
    theTeam <- input$team_4a
  } else {
    theTeam <- "Arsenal"
  }
  
  
  df <-  data.frame(standings %>%
                      filter(tmYrGameOrder==games&team==theTeam) %>%
                      select(Season=season,Pos=position,Pts=cumPts,GD=cumGD,GF=cumGF,Final=final_Pos)) 
  
  DT::datatable(df,options= list(paging = FALSE, searching = FALSE, info=FALSE,
                                 
                                 order=list(c(0,'desc'))))
                                 
}
)

output$currentForm <- DT::renderDataTable({
  print("enter current form")
  
  
  if (!is.null(input$games_5)) {
    games <- input$games_5
  } else {
    games <- 6
  }
  
  current <- standings %>%
    filter(season==currentYear&tmYrGameOrder==currentRound) %>%
    select(team,Pl=tmYrGameOrder,Pts=cumPts,GD=cumGD,GF=cumGF)
  
  past <- standings %>%
    filter(season==currentYear&tmYrGameOrder==(currentRound-games)) %>%
    select(team,oldPl=tmYrGameOrder,oldPts=cumPts,oldGD=cumGD,oldGF=cumGF) %>%
    inner_join(current) %>%
    mutate(Pl=Pl-oldPl,Pts=Pts-oldPts,GD=GD-oldGD,GF=GF-oldGF) %>%
    select(team,Pl,Pts,GD,GF) %>%
    ungroup() %>%
    arrange(desc(Pts),desc(GD),desc(GF),team) %>%
    mutate(position=row_number()) %>%
    select(7,2:6)
  DT::datatable(past,options= list(paging = FALSE, searching = FALSE, ordering=FALSE,info=FALSE))
})


output$datetableNow <- DT::renderDataTable({
  
  
  if (!is.null(input$date_1)) {
    theDate <- input$date_1
  } else {
    theDate - Sys.Date()
  }
  
  if (month(theDate)<6) {
    yr <-paste(year(theDate)-1,str_sub(year(theDate),3,4),sep="/")
  }else {
    yr <-paste(year(theDate),as.integer(str_sub(year(theDate),3,4))+1,sep="/")
  }
  print(yr)
  print(glimpse(standings))
  table <-standings %>%
    filter(season==yr&gameDate<=theDate)  %>%  #478 loks good
    group_by(team) %>%
    transmute(Pl=n(),Pts=sum(points),GA=sum(GA),GF=sum(GF)) %>%
    mutate(GD=GF-GA) 
  table <- unique(table)
  
  table <- data.frame(table)
  table <-   table  %>% 
    arrange(desc(Pts),desc(GD),desc(GF),team) %>%
    mutate(position=row_number()) %>%
    select(Pos=position,Team=team,Pl,Pts,GD)
  DT::datatable(table,options= list(paging = FALSE, searching = FALSE, info=FALSE,
                                    order=list(c(3,'desc'),c(4,'desc'),c(1,'asc'))))
}
)

output$datetableRest <- DT::renderDataTable({
  
  
  if (!is.null(input$date_1)) {
    theDate <- input$date_1
  } else {
    theDate - Sys.Date()
  }
  
  if (month(theDate)<6) {
    yr <-paste(year(theDate)-1,str_sub(year(theDate),3,4),sep="/")
  }else {
    yr <-paste(year(theDate),as.integer(str_sub(year(theDate),3,4))+1,sep="/")
  }
  table <-standings %>%
    filter(season==yr&gameDate>theDate)  %>%  
    group_by(team) %>%
    transmute(Pl=n(),Pts=sum(points),GA=sum(GA),GF=sum(GF)) %>%
    mutate(GD=GF-GA) 
  table <- unique(table)
  
  table <- data.frame(table)
  table  %<>% 
    arrange(desc(Pts),desc(GD),desc(GF),team) %>%
    mutate(position=row_number()) %>%
    select(Pos=position,Team=team,Pl,Pts,GD)
  DT::datatable(table,options= list(paging = FALSE, searching = FALSE, info=FALSE,
                                    order=list(c(3,'desc'),c(4,'desc'),c(1,'asc'))))
} 
)

output$datetableYear <- DT::renderDataTable({
  
  
  if (!is.null(input$date_1)) {
    theDate <- input$date_1
  } else {
    theDate - Sys.Date()
  }
  
  if (month(theDate)<6) {
    yr <-paste(year(theDate)-1,str_sub(year(theDate),3,4),sep="/")
  }else {
    yr <-paste(year(theDate),as.integer(str_sub(year(theDate),3,4))+1,sep="/")
  }
  table <-standings %>%
    filter(season==yr)  %>%  
    group_by(team) %>%
    transmute(Pl=n(),Pts=sum(points),GA=sum(GA),GF=sum(GF)) %>%
    mutate(GD=GF-GA) 
  table <- unique(table)
  
  table <- data.frame(table)
table <-  table  %>% 
    arrange(desc(Pts),desc(GD),desc(GF),team) %>%
    mutate(position=row_number()) %>%
    select(Pos=position,Team=team,Pl,Pts,GD)
  
  DT::datatable(table,options= list(paging = FALSE, searching = FALSE, info=FALSE,
                                    order=list(c(3,'desc'),c(4,'desc'),c(1,'asc')))) 
}
)
