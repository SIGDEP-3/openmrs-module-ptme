package org.openmrs.module.ptme.forms.validators;

import org.openmrs.Patient;
import org.openmrs.annotation.Handler;
import org.openmrs.api.context.Context;
import org.openmrs.module.ptme.PregnantPatient;
import org.openmrs.module.ptme.api.PreventTransmissionService;
import org.openmrs.module.ptme.forms.ConsultationForm;
import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import java.util.regex.Pattern;

@Handler(supports = {ConsultationForm.class}, order = 50)
public class PrenatalFormValidator implements Validator {

    @Override
    public boolean supports(Class c) {
        return c.equals(ConsultationForm.class);
    }

    @Override
    public void validate(Object o, Errors errors) {
        ConsultationForm form = (ConsultationForm) o;

        if(form == null) {
            errors.reject("ptme", "general.error");
        } else {
            ValidationUtils.rejectIfEmpty(errors, "consultationDate", "ptme.field.required");

            ValidationUtils.rejectIfEmpty(errors, "pregnantNumber", "ptme.field.required");
            ValidationUtils.rejectIfEmpty(errors, "age", "ptme.field.required");

            ValidationUtils.rejectIfEmpty(errors, "hivStatusAtReception", "ptme.field.required");
            ValidationUtils.rejectIfEmpty(errors, "testProposal", "ptme.field.required");
            ValidationUtils.rejectIfEmpty(errors, "testResult", "ptme.field.required");
            ValidationUtils.rejectIfEmpty(errors, "resultAnnouncement", "ptme.field.required");
            ValidationUtils.rejectIfEmpty(errors, "arvDiscount", "ptme.field.required");
            ValidationUtils.rejectIfEmpty(errors, "arvStatus", "ptme.field.required");

            ValidationUtils.rejectIfEmpty(errors, "prenatalRank", "ptme.field.required");
            ValidationUtils.rejectIfEmpty(errors, "weekOfAmenorrhea", "ptme.field.required");

            Pattern weekPattern = Pattern.compile("^[1-5][0-9]?$", Pattern.CASE_INSENSITIVE);
            if (form.getWeekOfAmenorrhea() != null && (!weekPattern.matcher(form.getWeekOfAmenorrhea().toString()).matches() && form.getWeekOfAmenorrhea() < 0)){
                errors.rejectValue("weekOfAmenorrhea", "ptme.non.valid.week.amenorrhea");
            }

            if((form.getSpousalScreening() != null && form.getSpousalScreening() != null)
                    && (form.getSpousalScreening() == 0 || form.getSpousalScreening() == 2)) {

                if (form.getSpousalScreeningResult() == 0 || form.getSpousalScreeningResult() == 1) {
                    errors.rejectValue("spousalScreeningResult", "ptme.non.screening.result");
                }
            }

            if (!form.getHivCareNumber().isEmpty()) {
                Pattern pattern = Pattern.compile("^[0-9]{4}/.{2}/[0-9]{2}/[0-9]{5}E?[1-9]?$", Pattern.CASE_INSENSITIVE);
                if (!pattern.matcher(form.getHivCareNumber()).matches()) {
                    errors.rejectValue("hivCareNumber", "ptme.invalid.hiv.number");
                } else {
                    PregnantPatient pregnantPatient = Context.getService(PreventTransmissionService.class).getPregnantPatientByHivCareNumber(form.getHivCareNumber());
                    if (pregnantPatient != null && (!pregnantPatient.getPregnantPatientId().equals(form.getPregnantPatientId()))) {
                        String pregnantNumber = pregnantPatient.getPregnantNumber();
                        errors.rejectValue("hivCareNumber", null, "Numéro déjà attribué à : " + pregnantNumber);
                    } else {
                        Patient patient = Context.getService(PreventTransmissionService.class).getPatientByIdentifier(form.getHivCareNumber());
                        if (patient != null && patient.getGender().equals("M")) {
                            errors.rejectValue("hivCareNumber", "ptme.number.not.for.female");
                        }
                    }
                }
            }

            Pattern agePattern = Pattern.compile("^([1-9])[0-9]{0,2}$", Pattern.CASE_INSENSITIVE);
            if (form.getAge() != null) {
                String ageString = form.getAge().toString();
                if(!agePattern.matcher(ageString).matches() || form.getAge() < 8 || form.getAge() > 120){
                    errors.rejectValue("age", "ptme.non.valid.age");
                }
            }

            if((form.getHivStatusAtReception() != null && form.getTestProposal() != null)
                    && form.getHivStatusAtReception() == 1 && form.getTestProposal() == 1) {
                errors.rejectValue("testProposal", "ptme.hiv.plus.noTest");
            }

            if((form.getTestProposal() != null && form.getTestProposal() != null) && (form.getTestProposal() == 0 || form.getTestProposal() == 2)) {

                if ((form.getHivStatusAtReception() == 0 || form.getHivStatusAtReception() == 2) &&
                        (form.getTestResult() == 0 || form.getTestResult() == 1)) {
                    errors.rejectValue("testResult", "ptme.non.test.result");
                }
            }

            if((form.getTestResult() != null && form.getTestProposal() != null) && form.getTestResult() == 1 && form.getTestProposal() == 2) {
                errors.rejectValue("testResult", "ptme.test.result.required");
            }

            if((form.getResultAnnouncement() != null && form.getTestProposal() != null)
                    && form.getResultAnnouncement() == 1 && form.getTestProposal() == 2) {
                errors.rejectValue("resultAnnouncement", "ptme.test.announcement.not.valid");
            }

            if((form.getArvDiscount() != null) && (form.getArvDiscount() == 1)) {

                if ((form.getHivStatusAtReception() != 1) && (form.getTestResult() != 1)) {
                    errors.rejectValue("arvDiscount", "ptme.non.hiv.discount");
                }
            }

            if(form.getArvStatus() != null && form.getArvStatus() == 1) {

                if (form.getHivStatusAtReception() != 1) {
                    errors.rejectValue("arvStatus", "ptme.non.hiv.on.arv");
                }
            }

            if(form.getAppointmentDate() != null && form.getConsultationDate() != null) {
                if (form.getConsultationDate().after(form.getAppointmentDate())) {
                    errors.rejectValue("appointmentDate", null, "La date de rendez-vous est avant la date de consultation !");
                } else if( form.getConsultationDate().equals(form.getAppointmentDate())) {
                    errors.rejectValue("appointmentDate", null, "La date de rendez-vous correspond à la date de consultation !");
                }
            }
        }
    }
}
