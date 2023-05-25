# Requiring libraries ----------------------------------------------------------
library("openxlsx")
library("dplR")
library("reshape")
library("mgcv")

# ------------------------------------------------------------------------------
# Functions --------------------------------------------------------------------
# ------------------------------------------------------------------------------
## --------------------------------------------------------------- load.files ####
## Load source files into list
##
## optimalized for .rwl, .txt, .csv and .xlsx;
## each file is a one element of the new list;
## list element name = the name of the input file;
#
# Arguments:
# folder 	- source folder
# types 	- files type
# separator 	- character sepparating individual columns (aplicable for txt and csv files)
# dec		- character delimiting decimals (aplicable for txt and csv files)
#
load.files<-function(folder,
                     types="rwl",
                     separator=";",
                     decimal="."){
  
  files<-list.files(folder)                                                     			# create vector with names of all elements in imput foder
  files<-files[grep(types,files)]                                               			# ommit files by file type
  output<-list()                                                                			# inicialization of output list
  for(i in 1:length(files)){  
    if(types=="txt") output[[i]]<-read.table(paste0(folder,"/",files[i]),sep=separator,dec=decimal,row.names=1)
    if(types=="csv") output[[i]]<-read.table(paste0(folder,"/",files[i]),sep=separator,dec=decimal,row.names=1)
    if(types=="xlsx")output[[i]]<-read.xlsx(paste0(folder,"/",files[i]))
    if(types=="rwl") output[[i]]<-read.rwl(paste0(folder,"/",files[i]))
  }                                                							# for loop of data reading
  names(output)<-gsub(paste0(".",types),"",files)                                                    	# renaming list elements
  return(output)
}

## ---------------------------------------------------------- prepare.dataset ####
## Prepare dataset for each sites for GAM fitting
##
## based on tidyvese approach
## each list element represents one site
## requires function "melt" implemented in package "reshape" 
#
# site.list 	- file containing metadata of individual sites
# tree.core 	- inplicit output from TreeDataClim database
# min.trees 	- limitations of minimal number of tree per site (implicit is 5)
# min out yera 	- limitation of calendar year (implicit is 2014)
#
prepare.dataset<-function(site.list,
                          tree.core,
                          min.trees=5,
                          min.out.year=2014){
  
  # output list
  output.main<-list()
  
  # Beginning of the for loop of data preparation, the number of itterations is set by number of sites in tree.core file
  for(i in unique(tree.core$site)){
    # subset of specific site
    sub.data<-subset(tree.core,site==i)
    
    # check! -chacking minimum number of trees per site
    if(length(unique(sub.data$tree))>=min.trees  & max(as.numeric(as.character(sub.data$year)))>=min.out.year){
      
      # check! - the TRW value
      if(max(sub.data$TRW,na.rm=T)>100) sub.data$TRW<-sub.data$TRW/100
      
      # aggregating TRW data of individual trees
      output.site<-aggregate(TRW~year+tree,sub.data,mean,na.rm=T)
      
      # assigning site name. If the site has no nema, then "some site" is assigned
      site.name<-"some site"
      ind<-which(site.list$site_code==i)
      if(length(ind)>0) site.name<-site.list$site_name[ind]
      
      # Output data frame for one site
      output.temp<-data.frame(Sitecode=as.character(unique(sub.data$site)), # site name based on the database ID
                              Sitename=site.name, # site name assigned to the site by the collecting institution
                              Species=as.character(unique(sub.data$species)), # species name
                              TreeID=output.site$tree, # treeID
                              calendar.year=output.site$year, # calendar year
                              cambial.age=NA, # cambial age
                              cum.DBH=NA, # cumulative DBH
                              cum.BA=NA, # cumulative Basal Area
                              TRW=output.site$TRW, # Tree ring width
                              BAI=NA) # Basal area increment
      
      # calculating data of each individual tree
      for(j in unique(output.temp$TreeID)){
        inds<-which(output.temp$TreeID==j & !is.na(output.temp$TRW)) # ids of the tree in the output.temp
        
        # caluucalted BAI
        for.bai.trw<-data.frame(TRW=output.temp$TRW[inds]) 
        for.bai.p.o<-data.frame(series=c("TRW"),po=0)
        output.temp$BAI[inds]<-bai.in(for.bai.trw,for.bai.p.o)$TRW
        
        output.temp$cambial.age[inds]<-c(1:length(inds)) # adding cambial age
        output.temp$cum.DBH[inds]<-(cumsum(output.temp$TRW[inds])/10)*2 # adding cumulative DBH (in cm)
        output.temp$cum.BA[inds]<-round(cumsum(output.temp$BAI[inds])*0.01,2) # adding cumulative BAI (in cm^2)
      }
      output.main[[i]]<-output.temp # assigning created data.frame into output list
    }
  }
  return(output.main)
}

## --------------------------------------------------------- make.model.4site ####
## Calculates GAMM for one site 
##
## the output is the model result
#
# input         - data.frame containing data pro fitting (output of the prepare.dataset)
# gam.formula   - GAM formula
# random effects- specification of random effects (implicit is TreeID)
# min.trees 	- limitations of minimal number of tree per site (implicit is 5)
#
make.model.4site<-function(input,
                           gam.formula,
                           random.effects=list(TreeID=~1),
                           min.trees=5){
  
  # input=tree.data$C004048FASY
  # gam.formula=model.formula.bai
  # random.effects=list(TreeID=~1)
  # min.trees=5
  
  model<-NULL
  # fitting GAMM, if not applicable, GAM is fitted
  if(nrow(input)>=min.trees) {
    tryCatch({
      model<-gamm(gam.formula,random=random.effects,data=input)$gam
    }, error=function(e) {
      model<-gam(gam.formula,random=random.effects,data=input)
    })
    
  }else {
    model<-NULL
  }
  
  return(model)
}

## --------------------------------------------------------- calculate.models ####
## calculates GAMMs for entire dataset (for loop running make.model.4site)
##
## the output is a list contaning model outputs for all sites filling the criteria of minimum trees
#
# input         - data.frame containing data pro fitting (output of the prepare.dataset)
# gam.formula   - GAM formula
# random effects- specification of random effects (implicit is TreeID)
# min.trees 	- limitations of minimal number of tree per site (implicit is 5)
#
calculate.models<-function(input,
                           gam.formula,
                           random.effects=list(TreeID=~1),
                           min.trees=5){
  
  output<-list()
  for(i in names(input)) {
    output[[i]]<-make.model.4site(input[[i]],gam.formula,random.effects,min.trees)
  }
  return(output)
}
## --------------------------------------------------------- create.mean.tree ####
## creates mean tree for one site
#
# input 	- input data frame from list created by function prepare.dataset
# min.trees 	- limitations of minimal number of tree per site (implicit is 5)
# funkce 	- function specifiing the mean value used (argument of aggregate function, mean or median is prefered, quantile(x,probs(y)) may be used as well)
# prediction 	- to create smooth data, spline or GAM fit may be used to smooth the meean value (spline)
#
create.mean.tree<-function(input,
                           min.trees=5,
                           function_="median",
                           prediction="spline"){
  
  # input=tree.data$P810114PCAB
  # output.range="subset"
  # min.trees=5
  # function_="median"
  # prediction="spline"
  
  # initialization of temporary (helping) data.frame
  help.data<-data.frame(Sitecode=as.character(unique(input$Sitecode)), # ID nov?ho stromu
                        Sitename=as.character(unique(input$Sitename)),
                        Species=as.character(unique(input$Species)),
                        calendar.year=as.numeric(as.character(unique(input$calendar.year))), # kalend??n? roky v origin?ln?m souboru
                        sample.depth=NA, # sample depth
                        cambial.age=NA, cum.DBH=NA, cum.BA=NA) # inicializace pol? pro pr?m?rn? hodnoty
  
  # ordering of helping data.frame
  help.data<-help.data[order(help.data$calendar.year),]
  rownames(help.data)<-c(1:nrow(help.data))
  
  # calculation sample depth
  help.data$sample.depth<-aggregate(TreeID~calendar.year,input,function(x){length(x)})$TreeID
  
  # calculating mean cambial age
  help.data$cambial.age<-aggregate(cambial.age~calendar.year,input,function_)$cambial.age
  
  # calculating mean  DBH
  help.data$cum.DBH<-aggregate(cum.DBH~calendar.year,input,function_)$cum.DBH
  
  # calculating mean  BA
  help.data$cum.BA<-aggregate(cum.BA~calendar.year,input,function_)$cum.BA
  
  # omminting data by minimum trees
  help.data<-help.data[which(help.data$sample.depth>=min.trees),]
  
  # initialization of output data.frame
  output<-help.data
  
  ## Data fitting
  ## this is preffered to smooth "stairs" in the output datadata
  #
  # 10 degrees of freedom is used (it is expected that the data has continuously increasing character)
  if(prediction=="spline"){
    output$cambial.age<-predict(smooth.spline(x=help.data$calendar.year,y=help.data$cambial.age,df=10),x=output$calendar.year)$y
    output$cum.DBH<-predict(smooth.spline(x=help.data$calendar.year,y=help.data$cum.DBH,df=10),x=output$calendar.year)$y
    output$cum.BA<-predict(smooth.spline(x=help.data$calendar.year,y=help.data$cum.BA,df=10),x=output$calendar.year)$y
  }
  # parameter type is set to response to avoid turning the curve to negative direction
  if(prediction=="gam"){
    output$cambial.age<-predict(gam(cambial.age~s(calendar.year),data=help.data),newdata = output,type = "response")
    output$cum.DBH<-predict.gam(gam(cum.DBH~s(calendar.year),data=help.data),newdata = output,type = "response")
    output$cum.BA<-predict.gam(gam(cum.BA~s(calendar.year),data=help.data),newdata = output,type="response")
  }
  
  # ommiting output from NA values
  output<-na.omit(output)
  return(output)
}

## -------------------------------------------------------- create.mean.trees ####
## creates mean trees for the entire dataset (for loop create.mean.tree)
#
# input 	- input data frame from list created by function prepare.dataset
# min.trees 	- limitations of minimal number of tree per site (implicit is 5)
# function 	- function specifiing the mean value used (argument of aggregate function, mean or median is prefered, quantile(x,probs(y)) may be used as well)
# prediction 	- to create smooth data, spline or GAM fit may be used to smooth the meean value (spline)
#
create.mean.trees<-function(input,
                            min.trees=5,
                            function_="median",
                            prediction="spline"){
  
  output<-list()
  for(i in names(input)) {
    output[[i]]<-create.mean.tree(input[[i]],min.trees,function_,prediction)
  }
  
  return(output)
}


## ---------------------------------------------------------------- fit.site ####
## Fitting mean BAI for specific site
#
# input.model 	  - input GAMM calculated for site
# input.mean.tree - mean tree for a given site
# input.site 	  - subset of metadata of specific site
# standardization - data standardization procedure
#                 - none 
#                 - standardization - standardization from -X do +X based on mean and standard deviation
#                 - normalization - from -1 to 1 based on min/max values
#                 - mean.before - standardization using mean BAI in the period 1960-1989
#                 - mean - standardization using mean in the period of investigation
# subset.years 	  - period of data subset
#
fit.site<-function(input.model,
                   input.mean.tree,
                   input.site,
                   standardization="mean.before",
                   subset.years=c(1990:2022)){
  
  # input.mean.tree$TreeID<-"NewOne"
  ## predict GAMM
  if(standardization!="mean.before") input.mean.tree<-subset(input.mean.tree,calendar.year>=1990)
  prediction<-predict.gam(input.model,input.mean.tree,se=T, allow.new.levels = TRUE, type="response",newdata.guaranteed=TRUE)
  
  # output data.frame
  output<-data.frame(Sitecode=unique(input.mean.tree$Sitecode), # inherited sitecode
                     Sitename=unique(input.mean.tree$Sitename), # inherited sitename
                     Species=unique(input.mean.tree$Species), # inherited species
                     calendar.year=input.mean.tree$calendar.year) # inherited calendar years
  
  # output subset
  if(standardization != "mean.before") output<-output[which(output$calendar.year %in% subset.years),]
  
  ## Data standardization
  # none
  if(standardization=="none"){ 
    output$fit<-prediction$fit
    output$se<-prediction$se.fit
  }
  # standardization
  if(standardization=="standardization"){
    output$fit<-(prediction$fit-mean(prediction$fit,na.rm=T))/sd(prediction$fit,na.rm=T)
    output$se<-output$fit-((prediction$fit-prediction$se.fit)-mean(prediction$fit,na.rm=T))/sd(prediction$fit,na.rm=T)
  } 
  # normalization
  if(standardization=="normalization"){
    output$fit<-(prediction$fit-min(prediction$fit))/(max(prediction$fit,na.rm=T)-min(prediction$fit,na.rm=T))
    output$se<-output$fit-(((prediction$fit-prediction$se.fit)-min(prediction$fit))/(max(prediction$fit,na.rm=T)-min(prediction$fit,na.rm=T)))
  } 
  # mean in the preceeding period
  if(standardization=="mean.before"){
    past.period<-c((min(subset.years)-30):(min(subset.years)-1))
    # values<-output$residual
    output$fit<-prediction$fit/mean(prediction$fit[which(output$calendar.year %in% past.period)])
    output$se<-output$fit-(prediction$fit-prediction$se.fit)/mean(prediction$fit[which(output$calendar.year %in% past.period)])
    output<-output[which(output$calendar.year %in% subset.years),]
  }
  # mean in the iperiod of investigation
  if(standardization=="mean"){
    output$fit<-prediction$fit/mean(prediction$fit)
    output$se<-output$fit-(prediction$fit-prediction$se.fit)/mean(prediction$fit)
  }
  
  return(output)
}
## --------------------------------------------------------------- fit.sites ####
## Fitting mean BAI for all sites in the dataset (for loop create.mean.tree)
#
# input.model 	  - input GAMM calculated for site
# input.mean.tree - mean tree for a given site
# input.site 	  - subset of metadata of specific site
# standardization - data standardization procedure
#                 - none 
#                 - standardization - standardization from -X do +X based on mean and standard deviation
#                 - normalization - from -1 to 1 based on min/max values
#                 - mean.before - standardization using mean BAI in the period 1960-1989
#                 - mean - standardization using mean in the period of investigation
# subset.years 	  - period of data subset
#
fit.sites<-function(input.models, 
                    input.mean.trees,
                    standardization="mean.before"){
  output<-list()
  for(i in names(input.models)){
    # print(i)
    output[[i]]<-fit.site(input.models[[i]], input.mean.trees[[i]], standardization)
  }
  return(output)
}
# ------------------------------------------------------------------------------
# Example of data preparation --------------------------------------------------
# ------------------------------------------------------------------------------
## Data preparation
site.list<-read.table("All_data/Site_meta/sites_all.csv",sep=",",header=T) # loading site meta
tree.core<-read.table("All_data/database_file/sampleTable.csv",sep=",")    # loading database data

# customization of database data
tree.core<-data.frame(site=tree.core[,1],
                      species=substr(tree.core[,1],8,11),
                      tree=formatC(tree.core[,2],width=4,flag="0"),
                      core=tree.core[,3],
                      year=tree.core[,4],
                      TRW=tree.core[,5]/100)

tree.data<-prepare.dataset(site.list, tree.core)

## Fitting GAMMs
model.formula<-formula(BAI~s(cambial.age)+s(cum.BA)+ti(cambial.age,cum.BA))
model.random.effects<-list(TreeID=~1)
models<-calculate.models(tree.data,model.formula,model.random.effects)

## Calculate tree means
mean.trees<-create.mean.trees(tree.data,min.trees=5, function_="median",prediction="gam")

# Fitting sites
fitted.sites<-fit.sites(models, mean.trees, "mean.before")
