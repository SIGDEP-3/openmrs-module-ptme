<%@ include file="/WEB-INF/template/include.jsp"%>
<openmrs:require privilege="Manage PTME" otherwise="/login.htm" redirect="/module/ptme/reportGenerate.form" />
<%@ include file="/WEB-INF/template/header.jsp"%>

<%@ include file="template/localHeader.jsp"%>

<style type="text/css">
    .selection {
        width: 200px;
    }
</style>

<script type="application/javascript">
    if (jQuery) {
        $(document).ready(function () {
            $("#list-generate").dataTable({
//                dom: 'B<"clear">lfrtip',
//                buttons: {
//                    name: 'primary',
//                    buttons: [ 'copy', 'csv', 'excel' ]
//                },
                "pageLength": 20,
                "order": [[2, "desc"]],
                "language": {
                    "zeroRecords": "Aucun rapport &agrave; afficher",
                    paginate: {
                        previous: 'Pr&eacute;c&eacute;dent',
                        next:     'Suivant'
                    },
                    "info":"Affichage de _START_ &agrave _END_ sur _TOTAL_ ",
                    "search": "Filtrer les rapports g&eacute;n&eacute;r&eacute;s"
                },
                "lengthChange": false,
                "stripeClasses": [ 'odd', 'even' ]
            });

            $(".indicator").dataTable({
                //"pageLength": 20,
                paginate: false,
                "info":     false,
                "searching": false,
                "order": [[0, "asc"]],
                "language": {
//                    "zeroRecords": "Aucun rapport &agrave; afficher",
//                    paginate: {
//                        previous: 'Pr&eacute;c&eacute;dent',
//                        next:     'Suivant'
//                    },
//                    "info":"Affichage de _START_ &agrave _END_ sur _TOTAL_ ",
//                    "search": "Filtrer les rapports g&eacute;n&eacute;r&eacute;s"
                },
                "lengthChange": false,
                "stripeClasses": [ 'odd', 'even' ]
            });

            $("#report").dataTable({
                dom: 'B<"clear">lfrtip',
                buttons: {
                    name: 'primary',
                    buttons: [ 'pdf', 'print' ]
                },
                paginate: false,
                "info":     false,
                "searching": false,
                "ordering": false,
                "lengthChange": false
                //"stripeClasses": [ 'odd', 'even' ]
            });

            $(".selection").css("width", "80px");

            var availableLocation = [
                ""
                <c:forEach  items="${locationList}" var="reportItemAvailable">
                    ,"${reportItemAvailable.name}"
                </c:forEach>
            ];

            $("#reportLocation").autocomplete({
                source: availableLocation
            });

        });
    }
</script>

<%@ include file="template/reportHeader.jsp"%>

<c:if test="${mode == 'list' || empty(mode)}">
    <div class="box">
        <h3><b>Rapports</b></h3>

        <div class="line"></div>
        <form:form action="" modelAttribute="getRunReportFormForm" id="form" method="get" >
            <table cellspacing="0" cellpadding="5">
                <tr>
                    <td><input type="submit" value="Nouveau Rapport" name="add"></td>
                </tr>
            </table>
        </form:form>
    </div>

    <div class="boxHeader"></div>
    <div class="box">
        <h3>Liste des Rapports g&eacute;n&eacute;r&eacute;s</h3>
        <div class="line"></div>
        <table width="100%" style="border: solid #1aac9b 1px" cellpadding="0" cellspacing="0" id="list-generate" class="hover">
            <thead>
            <tr style="background-color: #1aac9b; color: #ffffff;">
                <th>Rapport</th>
                <th>P&eacute;riode</th>
                <th>G&eacute;n&eacute;r&eacute; le</th>
                <th>Etablissement</th>
                <th>Date d&eacute;but </th>
                <th>Date de fin </th>
                <th>G&eacute;n&eacute;r&eacute; par</th>
                <th></th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="generatedReport" items="${ listGeneratedReports }">
                <tr>
                    <td>${generatedReport.report.reportLabel}</td>
                    <td>${generatedReport.name}</td>
                    <td><fmt:formatDate type="date" value="${generatedReport.generationDate}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                    <td>${generatedReport.reportLocation.name}</td>
                    <td><fmt:formatDate type="date" value="${generatedReport.reportPeriodStartDate}" pattern="dd/MM/yyyy" /></td>
                    <td><fmt:formatDate type="date" value="${generatedReport.reportPeriodEndDate}" pattern="dd/MM/yyyy" /></td>
                    <td>
                        <c:forEach var="person" items="${ generatedReport.creator.person.names }">
                            <%--<c:if test="${ person.preferred }">
                                ${person.familyName} ${person.givenName}
                            </c:if>--%>
                            ${person.familyName} ${person.middleName} ${person.givenName}
                        </c:forEach>
                    </td>
                    <td width="30">
                        <table cellpadding="0" cellspacing="0" class="button-table">
                            <tr>
                                <td>
                                    <c:url value="/module/ptme/reportGenerate.form" var="viewUrl">
                                        <c:param name="reportViewId" value="${generatedReport.generationId}"/>
                                    </c:url>
                                    <a href="${ viewUrl }"><img src="<c:url value="/images/file.gif"/>" alt="View"></a>
                                </td>
                                <td>|</td>
                                <td>
                                    <c:url value="/module/ptme/reportExcelView.form" var="excelUrl">
                                        <c:param name="reportExcelId" value="${generatedReport.generationId}"/>
                                    </c:url>
                                    <a href="${ excelUrl }" target="_blank"><img height="15px" width="16px" src="<c:url value="/moduleResources/ptme/images/excel.png"/>" alt="Excel"></a>
                                </td>
                                <c:if test="${generatedReport.saved == false}">
                                <td>|</td>
                                <td>
                                    <c:url value="/module/ptme/reportGenerate.form" var="saveUrl">
                                        <c:param name="reportSaveId" value="${generatedReport.generationId}"/>
                                    </c:url>
                                    <a href="${ saveUrl }"><img src="<c:url value="/images/save.gif"/>" alt="Save"></a>
                                </td>
                                </c:if>
                                <td>|</td>
                                <td>
                                    <c:url value="/module/ptme/reportGenerate.form" var="url">
                                        <c:param name="generationId" value="${generatedReport.generationId}"/>
                                    </c:url>
                                    <a href="${ url }"><img src="/openmrs/images/edit.gif" alt="Editer"></a>
                                </td>
                                <td>|</td>
                                <td>
                                    <c:url value="/module/ptme/reportGenerate.form" var="urlsup">
                                        <c:param name="delId" value="${generatedReport.generationId}"/>
                                    </c:url>
                                    <a href="${ urlsup }" onclick="return confirm('Voulez-vous vraiment supprimer la ligne ?');">
                                        <img src="/openmrs/images/trash.gif" alt="Supprimer">
                                    </a>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

</c:if>

<c:if test="${mode == 'form'}">
    <div class="box">
        <h3><b>Saisie des informations du rapport</b></h3>
        <div class="line"></div>
        <form:form action="" modelAttribute="runReportForm" id="form" method="post">
            <form:hidden path="generationId"/>
            <form:hidden path="generationDate"/>
            <form:hidden path="saved"/>
            <table cellspacing="0" cellpadding="5" align="">
                <tr>
                    <td>
                        <table cellpadding="5" cellspacing="0" width="100%">
                            <tr>
                                <td class="boldText">Rapport &agrave; g&eacute;n&eacute;rer <b class="required">*</b> : </td>
                                <td>
                                    <form:select path="reportId"  cssClass="selection">
                                        <<option value="">-- S&eacute;lectionner --</option>
                                        <c:forEach  items="${reportList}" var="reportItem">
                                            <option value="${reportItem.reportId}"
                                                    <c:if test="${reportItem.reportId== runReportForm.reportId}">selected="selected"</c:if> >
                                                    ${reportItem.reportLabel}
                                            </option>
                                        </c:forEach>
                                    </form:select>
                                </td>
                                <td><form:errors cssClass="error" path="reportId"/></td>
                            </tr>
                            <tr>
                                <td class="boldText">P&eacute;riode (Mois Ann&eacute;e) <b class="required">*</b> : </td>
                                <td><form:input path="name"  size="40" cssClass=""/></td>
                                <td><form:errors cssClass="error" path="name"/></td>
                            </tr>
                            <tr>
                                <td class="boldText">Date de d&eacute;but de p&eacute;riode <b class="required">*</b>  : </td>
                                <td><form:input path="reportPeriodStartDate" cssClass="datepickerPtme" /></td>
                                <td><form:errors cssClass="error" path="reportPeriodStartDate"/></td>
                            </tr>
                            <tr>
                                <td class="boldText">Date de fin de p&eacute;riode <b class="required">*</b>  : </td>
                                <td><form:input path="reportPeriodEndDate" cssClass="datepickerPtme" /></td>
                                <td><form:errors cssClass="error" path="reportPeriodEndDate"/></td>
                            </tr>
                            <tr>
                                <td class="boldText">Etablissement <b class="required">*</b> : </td>
                                <td><form:input path="reportLocation" cssClass="" size="80" /></td>
                                <td><form:errors cssClass="error" path="reportLocation"/></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <div class="line"></div>
            <table cellspacing="0" cellpadding="5">
                <tr>
                    <td>
                        <c:if test="${ empty runReportForm.generationId }">
                            <input type="submit" value="Executer" name="action"/>
                        </c:if>
                        <c:if test="${ not empty runReportForm.generationId }">
                            <input type="submit" value="Executer" name="action"/>
                        </c:if>
                        <button type="button" class="" onclick="document.location.href='${pageContext.request.contextPath}/module/ptme/reportGenerate.form'" >Annuler</button>
                    </td>
                </tr>
            </table>
        </form:form>
    </div>
</c:if>

<c:if test="${mode == 'view'}">
    <div class="box">
        <h3><b>Affichage du rapports</b></h3>
        <div class="line"></div>
        <table align="center" cellpadding="5" id="" width="850px">
            <thead>
            <tr style="border: 1px solid black; background-color:#1aac9b;" align="center">
                <th height="40px" align="center" style="text-align: center; color: #ffffff; font-size: 18px;">
                        ${reportGeneration.report.reportLabel}
                </th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td align="center">
                    <table width="100%" bgcolor="#d3d3d3" style="font-size: 16px; font-style:italic;" cellpadding="5">
                        <tr>
                            <td>Nom du rapport g&eacute;n&eacute;r&eacute;</td>
                            <td class="boldText">${reportGeneration.name}</td>
                            <td>G&eacute;n&eacute;r&eacute; le</td>
                            <td class="boldText"><fmt:formatDate type="date" value="${reportGeneration.generationDate}" pattern="dd/MM/yyyy HH:mm:ss" /></td>
                        </tr>

                        <tr>
                            <td>Date de d&eacute;but de p&eacute;riode :</td>
                            <td class="boldText"><fmt:formatDate type="date" value="${reportGeneration.reportPeriodStartDate}" pattern="dd/MM/yyyy" /></td>
                            <td>Date de fin de p&eacute;riode : </td>
                            <td class="boldText"><fmt:formatDate type="date" value="${reportGeneration.reportPeriodEndDate}" pattern="dd/MM/yyyy" /></td>
                        </tr>
                        <tr>
                            <td >Eatablissement :</td>
                            <td class="boldText">${reportGeneration.reportLocation.name}</td>
                            <td>G&eacute;n&eacute;r&eacute; par :</td>
                            <td class="boldText">
                                <c:forEach var="pers" items="${ reportGeneration.creator.person.names }">
                                    <%--<c:if test="${ pers.preferred }">
                                        ${pers.familyName} ${pers.givenName} ${pers.middleName}
                                    </c:if>--%>
                                    ${pers.familyName} ${pers.middleName} ${pers.givenName}
                                </c:forEach>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td align="center">
                    <c:forEach var="dataSet" items="${ reportValue.reportDataSetIndicatorRuns }">
                        <h3 style="margin-top: 20px">${dataSet.dataSetUuid}</h3>
                        <table width="700px" cellpadding="5" class="indicator">
                            <thead>
                            <tr style="background-color:#1aac9b; color: #ffffff;">

                                <th>Indicateurs</th>
                                <th>Effectif</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="indicator" items="${ dataSet.reportRunIndicatorValues }">
                                <tr>
                                    <td style="border-left: 1px solid #1aac9b; border-right: 1px solid #1aac9b" height="35px">${indicator.indicatorUuid}</td>
                                    <td style="border-right: 1px solid #1aac9b" width="100px" align="center">${indicator.value}</td>
                                </tr>
                            </c:forEach>
                            </tbody>

                        </table>
                    </c:forEach>
                </td>
            </tr>
            </tbody>
        </table>

</c:if>
<%@ include file="template/localFooter.jsp"%>

