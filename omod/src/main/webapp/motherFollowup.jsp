<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%--<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>--%>
<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="Manage PTME" otherwise="/login.htm" redirect="/module/ptme/motherFollowup.form" />
<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ include file="template/localHeader.jsp"%>

<script type="application/javascript">
    if (jQuery) {
        $(document).ready(function () {
//            $j.fn.dataTable.moment('dd/MM/yyyy');

            $("#list-mother-followup-table").dataTable({
                /*dom: 'B<"clear">lfrtip',
                buttons: {
                    name: 'primary',
                    buttons: [ 'copy', 'csv', 'excel' ]
                },*/
                "pageLength": 20,
                "order": [[1, "desc"]],
                "language": {
                    "zeroRecords": "Aucune visite &agrave; afficher",
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

<%@ include file="template/motherFollowupHeader.jsp"%>

<%--<div class="box">--%>
<%--&lt;%&ndash;<div class=""><h2><spring:message code="ptme.mother.followup.subtitle" /></h2></div>&ndash;%&gt;--%>
<%--</div>--%>

<c:if test="${mode == 'list' || empty(mode)}">

    <div class="box">
        <h3>Choix de la patiente</h3>
        <div class="line"></div>
        <form:form action="" modelAttribute="findPregnantPatientForm" id="form" method="get" >
            <form:hidden path="mode"/>
            <table cellpadding="10" cellspacing="0">
                <tr>
                    <td>Numero de prise en charge : </td>
                    <td><form:input path="hivCareNumber" cssClass=""/> </td>
                    <td><input type="submit" value="Saisir la fiche"></td>
                </tr>
            </table>
        </form:form>
    </div>
    <div class="boxHeader"></div>
    <div class="box">
        <h3>Liste des pateintes dont le suivi est en cours sur le site</h3>

        <div class="line"></div>

    <table id="list-mother-followup-table" style="border-collapse: collapse; border: 1px solid #1aac9b" cellpadding="5" cellspacing="0" width="100%">
            <thead>
            <tr style="background-color: #1aac9b; color: #ffffff;">
                <th>Numero de PEC</th>
                <th>Nom</th>
                <th>Prenom</th>
                <th>Deate de debut</th>
                <th>Statut ARV &agrave; l'enregistrement</th>
                <th>R&eacute;sultat VIH Conjoint</th>
                <th>Date d&eacute;pistage Conjoint</th>
                <th>Nombre de visite</th>
                <th>Date de derni&egrave;re visite</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="followupOn" items="${ listMotherFollowupOn }">
            <tr>
                <td>
                    <c:url value="/module/ptme/motherFollowup.form" var="url">
                        <c:param name="hivCareNumber" value="${followupOn.hivCareNumber}"/>
                    </c:url>
                    <a href="${ url }">${followupOn.hivCareNumber}</a>
                </td>
                <td>${followupOn.familyName}</td>
                <td>${followupOn.givenName}</td>
                <td><fmt:formatDate type="date" value="${followupOn.startDate}" pattern="dd/MM/yyyy" /></td>
                <td>${followupOn.arvStatusAtRegistering == 0 ? 'Positif sans ARV' : (followupOn.arvStatusAtRegistering == 1 ? 'Positif deja sous ARV': 'Nouvellement diagnostiquee VIH Positif') }</td>
                <td>${followupOn.spousalScreeningResult == 1 ? 'Positif' : (followupOn.spousalScreeningResult == 0 ? 'Negatif' : '')}</td>
                <td><fmt:formatDate type="date" value="${followupOn.spousalScreeningDate}" pattern="dd/MM/yyyy" /></td>
                <td>${followupOn.visitCount}</td>
                <td><fmt:formatDate type="date" value="${followupOn.lastVisitDate}" pattern="dd/MM/yyyy" /></td>
                <td width="10px">
                    <%--<table cellpadding="0" cellspacing="0" class="button-table">
                        <tr>
                            <td>
                                <c:url value="/module/ptme/motherFollowup.form" var="url">
                                    <c:param name="hivCareNumber" value="${followupOn.hivCareNumber}"/>
                                </c:url>
                                <a href="${ url }"><img src="/openmrs/images/edit.gif" alt="Editer"></a>
                            </td>
                            <td>|</td>
                            <td>--%>
                                <c:url value="/module/ptme/motherFollowup.form" var="urlsup">
                                    <c:param name="delFollowupId" value="${followupOn.motherFollowupId}"/>
                                </c:url>
                                <a href="${ urlsup }" onclick="return confirm('Voulez-vous vraiment supprimer la ligne ?');">
                                    <img src="/openmrs/images/trash.gif" alt="Supprimer">
                                </a>
                            <%--</td>
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
    <%--<div class="boxHeader"></div>--%>
    <div class="box">
        <h3><b>Saisie de la fiche</b> </h3>
        <div class="line"></div>
        <c:set var = "nbVisit" value = "${motherFollowupVisitsCount}"/>
        <c:set var = "constRowspan" value = "${nbVisit + 2}"/>
        <c:set var = "visitFormHeight" value = "${50}"/>
        <c:set var = "visitHeight" value = "${30}"/>
        <c:set var = "firstColHeight" value = "${410}"/>

        <form:form action="" modelAttribute="motherFollowupForm" id="form" method="post" >

            <form:hidden path="motherFollowupId"/>
            <form:hidden path="pregnantPatientId"/>
            <form:hidden path="startDate"/>
            <form:hidden path="motherFollowupVisitId"/>

            <%--<form:errors cssClass="error" path="visitDate"/>--%>

            <table class="table-mother-followup" align="center" style="background-color: #efefef">
                <thead>
                <tr>
                    <th rowspan="3" width="160px" height="170px"></th>
                    <th rowspan="3">Date de <br>la visite</th>
                    <th rowspan="3">Age <br>gestationnel <br>(en semaine <br>d'amenorrhee)</th>
                    <th rowspan="3">Statut <br>ARV a <br>l'enregistrement</th>
                    <th rowspan="3">Date <br>d'initiation <br>du traitement <br>ARV</th>
                    <th rowspan="3">Mere <br>toujours <br>sous ARV ? <br>(Oui / Non)</th>
                    <th rowspan="3">Cotrimoxazole</th>
                    <th>Depistage VIH<br>du conjoint</th>
                    <th rowspan="3">Issue <br>de la <br>grossesse</th>
                    <th rowspan="3">Accouchement</th>
                    <th rowspan="3"></th>
                </tr>
                <tr>
                    <th>Resultat</th>
                </tr>
                <tr>
                    <th>Date <br>du <br>depistage</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td class="bordered-green" rowspan="${constRowspan}"
                        height="${(visitFormHeight + visitHeight * nbVisit ) < firstColHeight ? firstColHeight : firstColHeight + nbVisit * visitHeight }px" >
                        Numero d'identification <br>
                        unique :<br>
                        <b class="colored-blue">${patientInfo.identifier}</b>
                        <br>
                        <br>
                        Nom: <br>
                        <b class="colored-blue">${patientInfo.familyName} ${patientInfo.givenName}</b>
                        <br>
                        <br>
                        Date de naissance :<br>
                        <b class="colored-blue"><fmt:formatDate type="date" value="${patientInfo.birthDate}" pattern="dd/MM/yyyy" /></b>
                        <br>
                        <br>
                        Age (ans):<br>
                        <b class="colored-blue">${patientInfo.age}</b>
                        <br>
                        <br>

                        Date Probable <br>
                        d'Accouchement : <br>
                        <b class="colored-blue">
                            <fmt:formatDate type="date" value="${patientInfo.outcomeProbableDate}" pattern="dd/MM/yyyy" />
                        </b>
                        <br>
                        <br>
                        Type de VIH :
                        <br>
                        <br>
                        <b class="colored-blue">${patientInfo.hivType}</b>

                        <br>
                        <br>
                        Contacts Telephonique :
                        <br>
                        Tel: <b class="colored-blue">${patientInfo.tel}</b>
                        <br>
                        Cel: <b class="colored-blue">${patientInfo.cel}</b><br>

                    </td>
                    <td class="bordered-green" height="${visitFormHeight}px" align="center">
                        <form:input  path="visitDate" cssClass="datepickerPtme" cssErrorClass="error" size="10px"/>
                    </td>
                    <td class="bordered-green" height="" align="center">
                        <form:input  path="gestationalAge" cssClass="" size="6px"/>
                    </td>
                    <td class="bordered-green" rowspan="${constRowspan}" align="center">
                        <form:radiobutton value="0" path="arvStatusAtRegistering" cssClass=""/> <br>
                        Positif <br>sans ARV <br><br><br>
                        <form:radiobutton value="1" path="arvStatusAtRegistering" cssClass=""/> <br>
                        Positif deja <br>sous ARV <br><br><br>
                        <form:radiobutton value="2" path="arvStatusAtRegistering" cssClass=""/><br>
                        Nouvellement <br>
                        diagnostiquee <br>
                        VIH Positif <br>
                    </td>
                    <td class="bordered-green" rowspan="${constRowspan}" align="center">
                        <b class="colored-blue">
                            <fmt:formatDate type="date" value="${patientInfo.hivCareBeginning}" pattern="dd/MM/yyyy" />
                        </b>
                    </td>
                    <td class="bordered-green" height="" align="center">
                        <table align="center" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="center"><form:radiobutton value="1" path="continuingArv" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="0" path="continuingArv" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="2" path="continuingArv" cssClass=""/></td>
                            </tr>
                            <tr>
                                <td align="center">Oui</td>
                                <td align="center">Non</td>
                                <td align="center">NA</td>
                            </tr>
                        </table>
                    </td>
                    <td class="bordered-green" height="">
                        <table align="center" cellspacing="0" cellpadding="0">
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
                        <table align="center" cellspacing="0" cellpadding="0">
                            <tr>
                                <td align="center"><form:radiobutton value="1" path="spousalScreeningResult" cssClass=""/></td>
                                <td align="center"><form:radiobutton value="0" path="spousalScreeningResult" cssClass=""/></td>
                            </tr>
                            <tr>
                                <td align="center">Postitif</td>
                                <td align="center">Negatif</td>
                            </tr>
                        </table>
                        <br><br>
                        <br><br>
                        <hr>
                        <br><br>
                        <br><br>
                        <form:input  path="spousalScreeningDate" cssClass="datepickerPtme"  size="10px"/>
                    </td>
                    <td class="bordered-green" rowspan="${constRowspan}" align="center">
                            <%-- Issue de grossesse--%>
                        <form:radiobutton value="1" path="pregnancyOutcome" cssClass=""/> <br>
                        A terme <br><br> <br>
                        <form:radiobutton value="2" path="pregnancyOutcome" cssClass=""/> <br>
                        Pr&eacute;maturit&eacute; <br><br><br>
                        <form:radiobutton value="3" path="pregnancyOutcome" cssClass=""/><br>
                        Avortement <br>/ Fausse <br>couche <br><br><br>
                        Mort-n&eacute;: <br>
                        Frais <form:radiobutton value="4" path="pregnancyOutcome" cssClass=""/><br>

                        Mac&eacute;r&eacute; <form:radiobutton value="5" path="pregnancyOutcome" cssClass=""/>
                    </td>
                    <td class="bordered-green" rowspan="${constRowspan}" align="center">
                        <form:radiobutton value="1" path="deliveryType" cssClass=""/> <br>
                        Unique <br><br> <br>
                        <form:radiobutton value="2" path="deliveryType" cssClass=""/> <br>
                        G&eacute;mellaire <br><br><br>
                    </td>
                    <td class="bordered-green" align="center">
                        <input type="submit" value="Valider">
                    </td>
                </tr>

                <c:forEach var="visit" items="${ motherFollowupVisits }">
                    <tr bgcolor="#E2E4FF">
                        <td class="bordered-green colored-blue boldText" align="center" height="${visitHeight}px">
                            <fmt:formatDate type="date" value="${ visit.visitDate }" pattern="dd/MM/yyyy" />
                        </td>
                        <td class="bordered-green colored-blue boldText" align="center">
                                ${ visit.gestationalAge }
                        </td>
                        <td class="bordered-green" align="center">
                            <table align="center" cellspacing="0" cellpadding="5">
                                <tr>
                                    <td align="center" class="colored-blue boldText">${visit.continuingArv == 1 ? '&ofcir;' : '&cir;'}</td>
                                    <td align="center" class="colored-blue boldText">${visit.continuingArv == 0 ? '&ofcir;' : '&cir;'}</td>
                                    <td align="center" class="colored-blue boldText">${visit.continuingArv == 2 ? '&ofcir;' : '&cir;'}</td>
                                </tr>
                                <tr>
                                    <td align="center">Oui</td>
                                    <td align="center">Non</td>
                                    <td align="center">NA</td>
                                </tr>
                            </table>
                        </td>
                        <td class="bordered-green" align="center">
                            <table align="center" cellspacing="0" cellpadding="5">
                                <tr>
                                    <td align="center" class="colored-blue boldText">${visit.continuingCtx == 1 ? '&ofcir;' : '&cir;'}</td>
                                    <td align="center" class="colored-blue boldText">${visit.continuingCtx == 0 ? '&ofcir;' : '&cir;'}</td>
                                </tr>
                                <tr>
                                    <td align="center">Oui</td>
                                    <td align="center">Non</td>
                                </tr>
                            </table>
                        </td>
                        <%--<td class="bordered-green colored-blue boldText" align="center">
                                ${ (visit.continuingArv == 0) ? 'Non' : (visit.continuingArv == 1 ? 'Oui' :  (visit.continuingArv == 2 ? 'N/A' : ''))}
                        </td>
                        <td class="bordered-green colored-blue boldText" align="center">${ (visit.continuingCtx == 0) ? 'Non' : (visit.continuingCtx == 1 ? 'Oui' : '')}</td>--%>
                        <td class="bordered-green" align="center">
                            <c:url value="/module/ptme/motherFollowup.form" var="url">
                                <c:param name="motherFollowupId" value="${motherFollowupForm.motherFollowupId}"/>
                                <c:param name="motherFollowupVisitId" value="${visit.motherFollowupVisitId }"/>
                            </c:url>
                            <a href="${ url }"><img src="/openmrs/images/edit.gif" alt="Editer"></a> |
                            <c:url value="/module/ptme/motherFollowup.form" var="urlsup">
                                <c:param name="motherFollowupId" value="${motherFollowupForm.motherFollowupId}"/>
                                <c:param name="delId" value="${visit.motherFollowupVisitId }"/>
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
                    </tr>
                </c:if>

                </tbody>
            </table>

        </form:form>
    </div>
</c:if>

<%@ include file="template/localFooter.jsp"%>