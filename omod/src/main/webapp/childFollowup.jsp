<%--<%@ taglib prefix="form" uri="http://struts.apache.org/tags-html" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%--<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>--%>
<%@ include file="/WEB-INF/template/include.jsp"%>

<openmrs:require privilege="Manage PTME" otherwise="/login.htm" redirect="/module/ptme/childFollowup.form" />

<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ include file="template/localHeader.jsp"%>

<script type="application/javascript">
    if (jQuery) {
        $(document).ready(function () {
            $("#list-child-followup-table").dataTable({

                /*dom: 'B<"clear">lfrtip',
                buttons: {
                    name: 'primary',
                    buttons: [ 'copy', 'csv', 'excel' ]
                },*/
                "pageLength": 20,
                "order": [[1, "asc"]],
                "language": {
                    "zeroRecords": "Aucun suivi d'enfant n'est en cours sur le site",
                    //"emptyTable": "Aucune donn&eacute;e",
                    paginate: {
                        previous: 'Pr&eacute;c&eacute;dent',
                        next:     'Suivant'
                    },
                    "info":"Affichage de _START_ a _END_ sur _TOTAL_ ",
                    "search": "Filtrer les visites"
                },
                "lengthChange": false,
                "stripeClasses": [ 'odd', 'even' ]

            });
        });
    }
</script>
<%@ include file="template/chlidFollowupHeader.jsp"%>
<%--<div class="box">--%>
<%--&lt;%&ndash;<div class=""><h2><spring:message code="ptme.mother.followup.subtitle" /></h2></div>&ndash;%&gt;--%>
<%--</div>--%>
<c:if test="${mode == 'list' || empty(mode)}">


    <div class="box">

        <h3><b>Choix de l'enfant</b></h3>
        <div class="line"></div>
        <form:form action="" modelAttribute="findChildForm" id="form" method="get" >
            <form:hidden path="mode"/>
            <table cellpadding="10" cellspacing="0">
                <tr>
                    <td>Numero d'identification : </td>
                    <td><form:input path="childFollowupNumber" cssClass=""/> </td>
                    <td><input type="submit" value="Saisir la fiche"></td>
                </tr>
            </table>
        </form:form>
    </div>
    <div class="boxHeader"></div>
    <div class="box">

        <h3><b>Liste des enfants dont le suivi est en cours sur le site</b></h3>
        <div class="line"></div>
        <table id="list-child-followup-table" style="border-collapse: collapse; border: 1px solid #1aac9b" cellpadding="5" cellspacing="0" width="100%">
            <thead>
            <tr style="background-color: #1aac9b; color: #ffffff;">
                <th align="center">Numero d'identification</th>
                <th align="center">Nom</th>
                <th align="center">Prenom</th>
                <th align="center">Sexe</th>
                <th align="center">Date de naissance</th>
                <th align="center">Derni&egrave;re PCR</th>
                <th align="center">Date Derni&egrave;re PCR</th>
                <th align="center">R&eacute;sultat Derni&egrave;re PCR</th>
                <th align="center">Date initiation CTX</th>
                <th align="center">Date initiation INH</th>
                <th align="center">Nombre de visite</th>
                <th align="center">Date de derni&egrave;re visite</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="followupOn" items="${ currentChildFollowup }">
            <tr>
                <td>
                    <c:url value="/module/ptme/childFollowup.form" var="url">
                        <c:param name="childFollowupNumber" value="${followupOn.childFollowupNumber}"/>
                    </c:url>
                    <a href="${ url }">${followupOn.childFollowupNumber}</a>
                </td>
                <td>${followupOn.familyName}</td>
                <td>${followupOn.givenName}</td>
                <td>${followupOn.gender}</td>
                <td><fmt:formatDate type="date" value="${followupOn.birthDate}" pattern="dd/MM/yyyy" /></td>
                <td>${followupOn.lastPcr}</td>
                <td><fmt:formatDate type="date" value="${followupOn.lastPcrDate}" pattern="dd/MM/yyyy" /></td>
                <td>${followupOn.lastPcrResult == 0 ? 'Negatif' : (followupOn.lastPcrResult == 1 ? 'Positif': '') }</td>
                <td><fmt:formatDate type="date" value="${followupOn.ctxInitiationDate}" pattern="dd/MM/yyyy" /></td>
                <td><fmt:formatDate type="date" value="${followupOn.inhInitiationDate}" pattern="dd/MM/yyyy" /></td>
                <td>${followupOn.visitCount}</td>
                <td><fmt:formatDate type="date" value="${followupOn.lastVisitDate}" pattern="dd/MM/yyyy" /></td>
                <td width="10px">
                    <%--<table cellspacing="0" cellpadding="0" class="button-table">
                        <tr>
                            <td>
                                <c:url value="/module/ptme/childFollowup.form" var="url">
                                    <c:param name="childFollowupNumber" value="${followupOn.childFollowupNumber}"/>
                                </c:url>
                                <a href="${ url }"><img src="/openmrs/images/edit.gif" alt="Editer"></a>
                            </td>
                            <td>|</td>
                            <td>--%>
                                <c:url value="/module/ptme/childFollowup.form" var="urlsup">
                                    <c:param name="delFollowupId" value="${followupOn.childId}"/>
                                </c:url>
                                <a href="${ urlsup }" onclick="return confirm('Voulez-vous vraiment supprimer la ligne ?');">
                                    <img src="/openmrs/images/trash.gif" alt="Supprimer">
                                </a>
                           <%-- </td>
                        </tr>
                    </table>--%>
                </td>
            </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</c:if>

<c:if test="${ mode == 'form'}">
    <h3><b>Saisie de la fiche de suivi de l'enfant expos&eacute;</b></h3>
    <div class="line"></div>
    <c:if test="${ not empty patientInfo }">
        <table cellspacing="0" cellpadding="5">
            <tr>
                <td class="boldText">Information sur la  m&egrave;re <span style="font-size: 15px">&blacktriangleright;</span> </td>
                <td>Num&eacute;ro identifiant : </td>
                <td class="colored-blue">${patientInfo.identifier}</td>
                <td>|</td>
                <td>Nom : </td>
                <td class="colored-blue">${patientInfo.familyName} ${patientInfo.givenName}</td>
                <td>|</td>
                <td>Age : </td>
                <td class="colored-blue">${patientInfo.age} ans</td>
                <td>|</td>
                <td>Contact : </td>
                <td class="colored-blue">${not empty patientInfo.tel ? patientInfo.tel : (not empty patientInfo.cel ? patientInfo.cel : 'Pas de contact') }</td>
                <td>|</td>
                <td>Type de VIH : </td>
                <td class="colored-blue">${patientInfo.hivType}</td>
            </tr>
        </table>
    </c:if>
    <c:if test="${ empty patientInfo }">
        <table cellspacing="0" cellpadding="5">
            <tr>
                <td class="boldText">Information sur la  m&egrave;re <span style="font-size: 15px">&blacktriangleright;</span> </td>
                <td class="colored-blue">M&egrave;re non prise en charge sur le site.
                    Mettre &agrave; jour si n&eacute;cessaire en modifiant les infos de l'enfant</td>
            </tr>
        </table>
    </c:if>
    <div class="line"></div>
    <table cellspacing="0" cellpadding="5">
        <tr>
            <td class="boldText">Information sur l'enfant <span style="font-size: 15px">&blacktriangleright;</span> </td>
            <td>Num&eacute;ro identifiant : </td>
            <td class="colored-blue">${currentChild.childFollowupNumber}</td>
            <td>|</td>
            <td>Nom : </td>
            <td class="colored-blue">${currentChild.familyName} ${currentChild.givenName}</td>
            <td>|</td>
            <td>Date de naissance : </td>
            <td class="colored-blue"><fmt:formatDate type="date" value="${currentChild.birthDate}" pattern="dd/MM/yyyy" /></td>
            <td>|</td>
            <td>Sexe : </td>
            <td class="colored-blue">${currentChild.gender}</td>
        </tr>
    </table>
    <div class="line"></div>
    <%--<div class="box">--%>
        <c:set var = "nbVisit" value = "${childFollowupVisitCount}"/>
        <c:set var = "constRowspan" value = "${nbVisit + 2}"/>
        <c:set var = "visitFormHeight" value = "${50}"/>
        <c:set var = "visitHeight" value = "${30}"/>
        <c:set var = "firstColHeight" value = "${310}"/>

        <form:form action="" modelAttribute="childFollowupForm" id="form" method="post" >

            <form:hidden path="childFollowupId"/>
            <form:hidden path="childFollowupVisitId"/>
            <form:hidden path="childId"/>

            <%--<form:errors cssClass="error" path="visitDate"/>--%>

            <table class="table-child-followup" align="center" cellspacing="0" cellpadding="5" style="background-color: #efefef">
                <thead>
                <tr>
                    <%--<th rowspan="5"&lt;%&ndash; width="160px" &ndash;%&gt; height="170px"></th>--%>
                    <th rowspan="5">Methode de <br>contraception <br>moderne <br>(Oui / Non)</th>
                    <th rowspan="2">Prophylaxie ARV <br>Remise a l'enfant? <br>(Oui / Non)</th>
                    <th rowspan="5">Date de <br>la visite</th>
                    <th rowspan="5">Age <br>au moment <br>de la viste <br>(en jour ou <br>en semaine <br>ou en mois)</th>
                    <th rowspan="2">Type <br>d'alimentation</th>
                    <%--<th rowspan="1" colspan="3">DBS-PCR</th>--%>
                    <th rowspan="1" colspan="1">DBS-PCR</th>
                    <th rowspan="2" colspan="2">Cotrimoxazole (CTX)</th>
                    <th rowspan="2" colspan="2">Prophylaxie <br> a l'isoniazide (INH)</th>
                    <th rowspan="2" colspan="1">Serologie ARV</th>
                    <th rowspan="5">Resultat final <br>du suivi</th>
                    <th rowspan="5"></th>
                </tr>
                <tr>
                    <th> Date <br> Age <br>R&eacute;sultat</th>
                    <%--<th>2e PCR</th>--%>
                    <%--<th>3e PCR</th>--%>
                </tr>
                <tr>
                    <th rowspan="3">Date<br>de<br>remise</th>
                    <th rowspan="3">
                        1=Allaitement <br>exclusif<br>
                        2=Alimentation <br>de remplacement <br>exclusif<br>
                        3=Alimentation de<br> complement<br>
                        4=Autres
                    </th>
                    <th>1er PCR</th>
                    <%--<th>Date du<br>prelevement</th>--%>
                    <%--<th>Date du<br>prelevement</th>--%>
                    <%--<th rowspan="2" colspan="2">Initiation CTX</th>--%>
                    <th rowspan="1" colspan="1">Initiation CTX</th>
                    <th rowspan="3" colspan="1">Enfant <br>sous CTX <br>(Oui / Non)</th>
                    <th rowspan="1" colspan="1">Initiation INH</th>
                    <%--<th rowspan="2" colspan="2">Initiation INH</th>--%>
                    <th rowspan="3" colspan="1">Enfant <br>sous INH <br>(Oui / Non)</th>
                    <th>Date</th>
                    <%--<th>Date</th>--%>
                </tr>
                <tr>
                    <th>2e PCR</th>
                    <%--<th>Age au <br>moment du <br>prelevement</th>--%>
                    <%--<th>Age au <br>moment du <br>prelevement</th>--%>
                    <th>Date</th>
                    <th>Date</th>
                    <%--<th>Age</th>--%>
                    <th>Age</th>
                </tr>
                <tr>
                    <th>3e PCR</th>
                    <%--<th>Resultat</th>--%>
                    <%--<th>Resultat</th>--%>
                    <%--<th>Age</th>--%>
                    <th>Age</th>
                    <th>Age</th>
                    <th>R&eacute;sultat</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <%--<td class="bordered-green" rowspan="${constRowspan}"--%>
                        <%--height="${firstColHeight}px" >--%>
                            <%--&lt;%&ndash;height="${(visitFormHeight + visitHeight * nbVisit ) < firstColHeight ? firstColHeight : firstColHeight + nbVisit * visitHeight }px" >&ndash;%&gt;--%>

                            <%--&lt;%&ndash;Nom de l'enfant: <br><br>&ndash;%&gt;--%>

                            <%--&lt;%&ndash;<br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<br><br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;N&compfn; d'identification <br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;unique :<br><br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<b class="colored-blue"></b>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<br><br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;Date de naissance :<br><br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<b class="colored-blue"></b>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<br><br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;Sexe :&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<br><br>&ndash;%&gt;--%>
                            <%--&lt;%&ndash;<b class="colored-blue"></b><br>&ndash;%&gt;--%>

                    <%--</td>--%>
                    <td class="bordered-green" height="${visitFormHeight}px">
                        <table align="center" cellspacing="0" cellpadding="5">
                            <tr>
                                <td align="center"><form:radiobutton value="true" path="modernContraceptiveMethod" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="false" path="modernContraceptiveMethod" cssClass=""/></td>
                            </tr>
                            <tr>
                                <td align="center">Oui</td>
                                <td align="center">Non</td>
                            </tr>
                        </table>
                    </td>
                    <td class="bordered-green" rowspan="${constRowspan}"
                        height="${firstColHeight}px" align="center">
                        <table align="center" cellspacing="0" cellpadding="5">
                            <tr>
                                <td align="center"><form:radiobutton value="1" path="arvProphylaxisGiven" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="0" path="arvProphylaxisGiven" cssClass=""/></td>
                            </tr>
                            <tr>
                                <td align="center">Oui</td>
                                <td align="center">Non</td>
                            </tr>
                        </table>
                        <br><br><br>
                        <form:input  path="arvProphylaxisGivenDate" cssClass="datepickerPtme centered" cssErrorClass="error" size="9px"/>
                    </td>
                    <td class="bordered-green" align="center">
                        <form:input  path="visitDate" cssClass="datepickerPtme centered" cssErrorClass="error" size="9px"/>
                    </td>
                    <td class="bordered-green" align="center">
                        <table>
                            <tr>
                                <td><form:input  path="ageInDay" cssClass="centered" cssErrorClass="error" size="1px"/></td>
                                <td><form:input  path="ageInWeek" cssClass="centered" cssErrorClass="error" size="1px"/></td>
                                <td><form:input  path="ageInMonth" cssClass="centered" cssErrorClass="error" size="1px"/></td>
                            </tr>
                            <tr>
                                <td align="center">J</td>
                                <td align="center">S</td>
                                <td align="center">M</td>
                            </tr>
                        </table>
                    </td>
                    <td class="bordered-green">
                        <table align="center" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="center"><form:radiobutton value="1" path="eatingType" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="2" path="eatingType" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="3" path="eatingType" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="4" path="eatingType" cssClass=""/></td>
                            </tr>
                            <tr>
                                <td align="center">1</td>
                                <td align="center">2</td>
                                <td align="center">3</td>
                                <td align="center">4</td>
                            </tr>
                        </table>
                    </td>
                    <td class="bordered-green" rowspan="${constRowspan}" align="center"
                        style="padding: 0;">

                        <table cellpadding="5" cellspacing="0" align="center" style="padding: 0; height: 100%" width="100%">
                            <%--<tr style="background-color: #1aac9b; color: white">--%>
                                <%--<td height="20px" style="border-bottom: 1px #1aac9b solid" align="center">--%>
                                    <%--1er PCR--%>
                                <%--</td>--%>
                            <%--</tr>--%>
                            <tr>
                                <td height="100%" style="border-bottom: 1px #1aac9b solid" align="center">
                                    <form:input path="pcr1SamplingDate" cssClass="datepickerPtme centered" size="9px"/> <br><br>

                                    <table>
                                        <tr>
                                            <td><form:input path="ageInWeekOnPcr1Sampling" cssClass="centered" size="1px"/></td>
                                            <td><form:input path="ageInMonthOnPcr1Sampling" cssClass="centered" size="1px"/></td>
                                        </tr>
                                        <tr>
                                            <td align="center">S</td>
                                            <td align="center">M</td>
                                        </tr>
                                    </table>
                                    <table align="center" cellspacing="0" cellpadding="5">
                                        <tr>
                                            <td align="center"><form:radiobutton value="1" path="pcr1Result" cssClass=""/></td>
                                            <td align="center"><form:radiobutton value="0" path="pcr1Result" cssClass=""/></td>
                                        </tr>
                                        <tr>
                                            <td align="center">Positif</td>
                                            <td align="center">Negatif</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <%--<tr style="background-color: #1aac9b; color: white">--%>
                                <%--<td height="20px" style="border-bottom: 1px #1aac9b solid" align="center">--%>
                                    <%--2e PCR--%>
                                <%--</td>--%>
                            <%--</tr>--%>
                            <tr>
                                <td height="100%" style="border-bottom: 1px #1aac9b solid" align="center">
                                    <form:input path="pcr2SamplingDate" cssClass="datepickerPtme centered" size="9px"/> <br><br>
                                    <table>
                                        <tr>
                                            <td><form:input path="ageInWeekOnPcr2Sampling" cssClass="centered" size="1px"/></td>
                                            <td><form:input path="ageInMonthOnPcr2Sampling" cssClass="centered" size="1px"/></td>
                                        </tr>
                                        <tr>
                                            <td align="center">S</td>
                                            <td align="center">M</td>
                                        </tr>
                                    </table>
                                    <table align="center" cellspacing="0" cellpadding="5">
                                        <tr>
                                            <td align="center"><form:radiobutton value="1" path="pcr2Result" cssClass=""/></td>
                                            <td align="center"><form:radiobutton value="0" path="pcr2Result" cssClass=""/></td>
                                        </tr>
                                        <tr>
                                            <td align="center">Positif</td>
                                            <td align="center">Negatif</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <%--<tr style="background-color: #1aac9b; color: white">--%>
                                <%--<td height="20px" style="border-bottom: 1px #1aac9b solid" align="center">--%>
                                    <%--3e PCR--%>
                                <%--</td>--%>
                            <%--</tr>--%>
                            <tr>
                                <td height="100%" align="center">
                                    <form:input path="pcr3SamplingDate" cssClass="datepickerPtme centered" size="9px"/> <br><br>
                                    <table>
                                        <tr>
                                            <td><form:input path="ageInWeekOnPcr3Sampling" cssClass="centered" size="1px"/></td>
                                            <td><form:input path="ageInMonthOnPcr3Sampling" cssClass="centered" size="1px"/></td>
                                        </tr>
                                        <tr>
                                            <td align="center">S</td>
                                            <td align="center">M</td>
                                        </tr>
                                    </table>
                                    <table align="center" cellspacing="0" cellpadding="5">
                                        <tr>
                                            <td align="center"><form:radiobutton value="1" path="pcr3Result" cssClass=""/></td>
                                            <td align="center"><form:radiobutton value="0" path="pcr3Result" cssClass=""/></td>
                                        </tr>
                                        <tr>
                                            <td align="center">Positif</td>
                                            <td align="center">Negatif</td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>

                        <%--<hr style="border-color: #1aac9b">--%>

                        <%--<hr style="width: 100%">--%>

                    </td>
                    <%--<td class="bordered-green" rowspan="${constRowspan}" align="center">--%>

                    <%--</td>--%>
                    <%--<td class="bordered-green" rowspan="${constRowspan}" align="center">--%>

                    <%--</td>--%>
                    <td class="bordered-green" rowspan="${constRowspan}" align="center">
                        <form:input path="ctxInitiationDate" cssClass="datepickerPtme centered" size="9px"/> <br><br><br>
                        <table>
                            <tr>
                                <td><form:input path="ageInWeekOnCtxInitiation" cssClass="centered" size="1px"/></td>
                                <td><form:input path="ageInMonthOnCtxInitiation" cssClass="centered" size="1px"/></td>
                            </tr>
                            <tr>
                                <td align="center">S</td>
                                <td align="center">M</td>
                            </tr>
                        </table>
                    </td>
                    <%--<td class="bordered-green" rowspan="${constRowspan}" align="center">--%>


                    <%--</td>--%>
                    <td class="bordered-green" height="" align="center">
                        <table align="center" cellspacing="0" cellpadding="5">
                            <tr>
                                <td align="center"><form:radiobutton value="1" path="continuingCtx" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="0" path="continuingCtx" cssClass=""/></td>
                            </tr>
                            <tr>
                                <td align="center">Oui</td>
                                <td align="center">Non</td>
                            </tr>
                        </table>
                    </td>
                    <td class="bordered-green" rowspan="${constRowspan}" align="center">
                        <form:input path="inhInitiationDate" cssClass="datepickerPtme centered" size="9px"/> <br> <br> <br>
                        <table>
                            <tr>
                                <td><form:input path="ageInWeekOnInhInitiation" cssClass="centered" size="1px"/></td>
                                <td><form:input path="ageInMonthOnInhInitiation" cssClass="centered" size="1px"/></td>
                            </tr>
                            <tr>
                                <td align="center">S</td>
                                <td align="center">M</td>
                            </tr>
                        </table>
                    </td>
                    <%--<td class="bordered-green" rowspan="${constRowspan}" align="center">--%>
                        <%----%>
                    <%--</td>--%>
                    <td class="bordered-green" height="" align="center">
                        <table align="center" cellspacing="0" cellpadding="5">
                            <tr>
                                <td align="center"><form:radiobutton value="1" path="continuingInh" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="0" path="continuingInh" cssClass=""/></td>
                            </tr>
                            <tr>
                                <td align="center">Oui</td>
                                <td align="center">Non</td>
                            </tr>
                        </table>
                    </td>
                    <td class="bordered-green" rowspan="${constRowspan}" align="center" style="padding: 0">
                        <form:input path="hivSerology1Date" cssClass="datepickerPtme centered" size="9px"/> <br><br>
                        <table>
                            <tr>
                                <td><form:input path="ageInWeekOnHivSerology1" cssClass="centered" size="1px"/></td>
                                <td><form:input path="ageInMonthOnHivSerology1" cssClass="centered" size="1px"/></td>
                            </tr>
                            <tr>
                                <td align="center">S</td>
                                <td align="center">M</td>
                            </tr>
                        </table>
                        <br>
                        <table align="center" cellspacing="0" cellpadding="5">
                            <tr>
                                <td align="center"><form:radiobutton value="1" path="hivSerology1Result" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="0" path="hivSerology1Result" cssClass=""/></td>
                            </tr>
                            <tr>
                                <td align="center">Positif</td>
                                <td align="center">Negatif</td>
                            </tr>
                        </table>
                        <br>
                        <hr>
                        <br>
                        <form:input path="hivSerology2Date" cssClass="datepickerPtme centered" size="9px"/> <br> <br>
                        <table>
                            <tr>
                                <td><form:input path="ageInWeekOnHivSerology2" cssClass="centered" size="1px"/></td>
                                <td><form:input path="ageInMonthOnHivSerology2" cssClass="centered" size="1px"/></td>
                            </tr>
                            <tr>
                                <td align="center">S</td>
                                <td align="center">M</td>
                            </tr>
                        </table>
                        <br>
                        <table align="center" cellspacing="0" cellpadding="5">
                            <tr>
                                <td align="center"><form:radiobutton value="1" path="hivSerology2Result" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="0" path="hivSerology2Result" cssClass=""/></td>
                            </tr>
                            <tr>
                                <td align="center">Positif</td>
                                <td align="center">Negatif</td>
                            </tr>
                        </table>
                    </td>
                    <%--<td class="bordered-green" rowspan="${constRowspan}" align="center">--%>
                        <%----%>
                    <%--</td>--%>
                    <td class="bordered-green" rowspan="${constRowspan}" align="left">
                        <form:radiobutton value="0" path="followupResult" cssClass="" label="Negatif sorti du programme"/><br><br>
                        <form:radiobutton value="1" path="followupResult" cssClass="" label="Perdue de vue"/><br><br>
                        <form:radiobutton value="2" path="followupResult" cssClass="" label="Decede"/><br><br>
                        <form:radiobutton value="3" path="followupResult" cssClass="" label="Positif adresse pour la PEC"/><br><br>
                        <form:radiobutton value="4" path="followupResult" cssClass="" label="Transfere"/><br><br>
                        <form:radiobutton value="5" path="followupResult" cssClass="" label="Refere"/><br><br>
                        Site de transfert <br>ou de reference : <br>
                        <form:textarea path="referenceLocation" rows="3" cols="25" />
                        <%--<form:input path="referenceLocation" cssClass=""/>--%>
                        <br><br>

                        Numero d'identification <br>unique : <br>
                        <form:input path="hivCareNumber" cssClass=""/><br><br>
                        Date du statut final : <br>
                        <form:input  path="followupResultDate" cssClass="datepickerPtme centered"  size="9px"/>
                    </td>
                    <td class="bordered-green" align="center">
                        <input type="submit" value="Valider">
                    </td>
                </tr>

                <c:forEach var="visit" items="${ childFollowupVisits }">
                    <tr bgcolor="#E2E4FF">
                        <td class="bordered-green" align="center" height="${visitHeight}px">
                            <table align="center" cellspacing="0" cellpadding="5">
                                <tr>
                                    <td align="center" class="centered colored-blue boldText">${ visit.modernContraceptiveMethod ? '&ofcir;' : '&cir;' }</td>
                                    <td align="center" class="centered colored-blue boldText">${ !visit.modernContraceptiveMethod ? '&ofcir;' : '&cir;' }</td>
                                </tr>
                                <tr>
                                    <td align="center">Oui</td>
                                    <td align="center">Non</td>
                                </tr>
                            </table>
                                <%--${ visit.modernContraceptiveMethod == true ? 'Oui' : (visit.modernContraceptiveMethod == false ? 'Non':'') }--%>
                        </td>
                        <td class="bordered-green colored-blue boldText" align="center">
                            <fmt:formatDate type="date" value="${ visit.visitDate }" pattern="dd/MM/yyyy" />
                        </td>
                        <td class="bordered-green" align="center">
                            <table cellpadding="2" cellspacing="3">
                                <tr>
                                    <td class="centered colored-blue boldText bordered-green">${ visit.ageInDay != null ? visit.ageInDay : '&nbsp;'}</td>
                                    <td class="centered colored-blue boldText bordered-green">${ visit.ageInWeek != null ? visit.ageInWeek : '&nbsp;'}</td>
                                    <td class="centered colored-blue boldText bordered-green">${ visit.ageInMonth != null ?  visit.ageInMonth : '&nbsp;'}</td>
                                </tr>
                                <tr>
                                    <td width="20" align="center">J</td>
                                    <td width="20" align="center">S</td>
                                    <td width="20" align="center">M</td>
                                </tr>
                            </table>
                        </td>
                        <td class="bordered-green" align="center">
                            <table align="center" cellspacing="0" cellpadding="5">
                                <tr>
                                    <td class="centered colored-blue boldText">${visit.eatingType == 1 ? '&ofcir;' : '&cir;'}</td>
                                    <td class="centered colored-blue boldText">${visit.eatingType == 2 ? '&ofcir;' : '&cir;'}</td>
                                    <td class="centered colored-blue boldText">${visit.eatingType == 3 ? '&ofcir;' : '&cir;'}</td>
                                    <td class="centered colored-blue boldText">${visit.eatingType == 4 ? '&ofcir;' : '&cir;'}</td>
                                </tr>
                                <tr>
                                    <td align="center">1</td>
                                    <td align="center">2</td>
                                    <td align="center">3</td>
                                    <td align="center">4</td>
                                </tr>
                            </table>
                                <%--${ (visit.eatingType == 1) ? 'Allaitement Exclusif' :--%>
                                        <%--(visit.eatingType == 2 ? 'Alimentation de remplacement Exclusif' :--%>
                                            <%--(visit.eatingType == 3 ? 'Alimentation de complement' :--%>
                                                 <%--(visit.eatingType == 4 ? 'Autre' : '')))}--%>
                        </td>
                        <td class="bordered-green" align="center">
                            <table align="center" cellspacing="0" cellpadding="5">
                                <tr>
                                    <td class="centered colored-blue boldText">${ visit.continuingCtx == 1 ? '&ofcir;' : '&cir;' }</td>
                                    <td class="centered colored-blue boldText">${ visit.continuingCtx == 0 ? '&ofcir;' : '&cir;' }</td>
                                </tr>
                                <tr>
                                    <td align="center">Oui</td>
                                    <td align="center">Non</td>
                                </tr>
                            </table>
                                <%--${ (visit.continuingCtx == 0) ? 'Non' : (visit.continuingCtx == 1 ? 'Oui' : '')}--%>
                        </td>
                        <td class="bordered-green" align="center">
                            <table align="center" cellspacing="0" cellpadding="5">
                                <tr>
                                    <td class="centered colored-blue boldText">${ visit.continuingInh == 1 ? '&ofcir;' : '&cir;' }</td>
                                    <td class="centered colored-blue boldText">${ visit.continuingInh == 0 ? '&ofcir;' : '&cir;' }</td>
                                </tr>
                                <tr>
                                    <td align="center">Oui</td>
                                    <td align="center">Non</td>
                                </tr>
                            </table>
                                <%--${ (visit.continuingInh == 0) ? 'Non' : (visit.continuingInh == 1 ? 'Oui' : '')}--%>
                        </td>
                        <td class="bordered-green" align="center">
                            <c:url value="/module/ptme/childFollowup.form" var="url">
                                    <c:param name="childFollowupNumber" value="${currentChild.childFollowupNumber}"/>
                                <c:param name="childFollowupVisitId" value="${visit.childFollowupVisitId }"/>
                            </c:url>
                            <a href="${ url }"><img src="/openmrs/images/edit.gif" alt="Editer"></a> |
                            <c:url value="/module/ptme/childFollowup.form" var="urlsup">
                                <c:param name="childFollowupNumber" value="${currentChild.childFollowupNumber}"/>
                                <c:param name="delId" value="${visit.childFollowupVisitId }"/>
                            </c:url>
                            <a href="${ urlsup }" onclick="return confirm('Voulez-vous vraiment supprimer la visite ?');">
                                <img src="/openmrs/images/trash.gif" alt="Supprimer">
                            </a>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${(visitFormHeight + visitHeight * nbVisit ) < firstColHeight}">
                    <tr>
                        <td class="bordered-green"></td>
                        <td class="bordered-green"></td>
                        <td class="bordered-green"></td>
                        <td class="bordered-green"></td>
                        <td class="bordered-green"></td>
                        <td class="bordered-green"></td>
                        <td class="bordered-green"></td>
                    </tr>
                </c:if>

                </tbody>
            </table>

        </form:form>
    <%--</div>--%>
</c:if>

<%@ include file="template/localFooter.jsp"%>