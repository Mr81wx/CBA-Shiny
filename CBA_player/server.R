#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)
library(ggsci)
library(plotly)
library(RANN)
library(sf)
Player_data<-read.csv("player_shiny.csv",row.names = 1)
Plot_data<-read.csv("cluster_zuobiao.csv",row.names = 1)
Pca_data<-read.csv("pca.csv",row.names = 1)
Player_dist<-as.matrix(dist(Pca_data[3:6]))
Plot_data$Cluster<-as.factor(Plot_data$Cluster)


get_playlist <- function(dteam,dseason){
  return(as.list(dplyr::filter(Player_data,Team.x==dteam&Season==dseason)$Player))
}

get_playdetail<- function(dtplayer){
  dat<-dplyr::filter(Player_data,dtplayer==Player)[2:30]
}

get_playplot<- function(dtplayer){
  dat<-dplyr::filter(Plot_data,grepl(dtplayer,Player_Season_Team))
}

get_plot<-function(dt){
  player_pc<-get_playplot(dt)
  Player_pot<-
    ggplot(Plot_data,aes(x=PC1, y=PC2,color=as.factor(Cluster),text=paste0(Player_Season_Team,"\n","位置类型",Cluster)))+
    geom_point(alpha=0.1,size=1.5) +
    theme(legend.position = "right")+
    geom_point(color="grey",alpha=0.7,size=1.5)+
    geom_path(data=player_pc,aes(x=PC1, y=PC2,group=1),color="black")+
    geom_point(data=player_pc,size=2)+
    scale_color_d3()+
    geom_rug(color="grey",alpha=0.7) + # great way to visualize points on a single axis
    geom_rug(data=player_pc) +
    theme_minimal() +
    geom_hline(aes(yintercept=0),linetype="dashed")+
    geom_vline(aes(xintercept=0),linetype="dashed")+
    scale_shape_manual(values=seq(0,15)) +
    theme(legend.position="none")+
    ggtitle(dt)+theme(title=element_text(family="STSong"),plot.title = element_text(hjust = 0.5))+
    labs(color="球员类型",
         x="PC1 数值越高表示综合能力越强",
         y="PC2 数值越高表示球员的打法越偏外线"
         )
  return(Player_pot)
}

# get_similar_player<-function(player_name,number){
#   list<-Player_dist[,grep(player_name,Player_data$Player_Season_Team)]
#   similar_id<-sort(list)[2:number+1]%>%names()
#   similar_names<-Player_data(similar_id,)$Player_Season_Team 
# }

shinyServer(function(input, output) {
    Player_list<-reactive({
      get_playlist(input$team,input$season)
    })
    output$VPlayer<- renderUI({
      selectInput('x', 'Select the Player: ', choices = Player_list())
    })
    
    output$p<- renderPlotly({
      p<-get_plot(input$x)
      Player_name<-paste0(input$x,"_",input$season,"_",input$team)
      list<-Player_dist[,grep(Player_name,Player_data$Player_Season_Team)]
      name_vec<-c("最相似的5个球员",as.vector(Player_data[names(sort(list)[2:6]),]$Player_Season_Team))
      p<-p+annotate("text",x=7,y=c(9,8.5,8,7.5,7,6.5),parse=TRUE,label=name_vec,size=3)
      ggplotly(p,tooltip="text")
    })
    
    output$t<- renderDataTable({
      get_playdetail(input$x)
    })
    
    
 })
