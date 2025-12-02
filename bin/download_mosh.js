#!/usr/local/bin/node
// #!/usr/local/bin/node
// #!/usr/bin/node

const mod_name = "download_mosh.js";
const func_name = `global`; // <== default, needs to be locally overwritten

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// design:

const tilde = "---===---";

// p = part , s = section , l = lecture
// TUNS-s00---===------===---The-Ultimate-Next.js-Series.xspf
// TUNS-s01-GS-l01---===---Getting_Started---===---Introduction.mp4
// TUNS-s01-GS-l02--Prerequisites.mp4

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// imports:

const { execSync } = require("node:child_process");

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .

const node_env = process.env.NODE_ENV; // undefined if undefined ;-)
const v_glob_verbose = node_env === "development";
// const DEBUG_THIS = v_glob_verbose;
const DEBUG_THIS = true;
//
function console_log_debug(func_name, ...args) {
  // API: const func_name = `console_log_debug`; console_log_debug(func_name, `my_var =`, my_var);
  if (DEBUG_THIS) {
    console.log(`# ${mod_name}:${func_name}`, ...args);
  }
}
console_log_debug(func_name, `Start`);

function console_log_print(func_name, ...args) {
  // API: const func_name = `console_log_print`; console_log_print(func_name, `my_var =`, my_var);
  console.log(`# ${mod_name}:${func_name}`, ...args);
}

function console_log_error(func_name, ...args) {
  // API: const func_name = `console_log_error`; console_log_error(func_name, `my_var =`, my_var);
  console.error(`# ${mod_name}:${func_name}`, ...args);
}
// const f_my_func = () => {
//   const func_name = "f_my_func";
//   // Note: the 'func_name' could also be fetched via this.name (see link) .. BUT .. code monifiers/webpack breaks this!
//   // - https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/name
//   console_log_debug(func_name, `start.`);
// };

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//

/**
 * Reads all data from the standard input (process.stdin) stream
 * and resolves with the complete content as a single string.
 *
 * @returns {Promise<string>} A promise that resolves with the file content.
 */
function fa_read_stdin_into_string() {
  const func_name = "fa_read_stdin_into_string()";
  console_log_debug(func_name, `start.`);
  //
  return new Promise((resolve, reject) => {
    let fileContent = "";
    process.stdin.setEncoding("utf8");
    process.stdin.on("data", (chunk) => {
      fileContent += chunk;
    });
    process.stdin.on("end", () => {
      process.stdin.removeListener("error", reject);
      resolve(fileContent);
    });
    process.stdin.on("error", (err) => {
      process.stdin.removeListener("end", resolve);
      reject(err);
    });
  });
  //
} // \function fa_read_stdin_into_string() {}

const f_obj_is_array = function (obj) {
  return obj && Array.isArray(obj);
};

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/substr <==== Deprecated
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/substring
const f_nr_to_padzero_string = function (nr, digits) {
  // better name: f_pre_padzero_string_to_nr_length(str, nr)
  var padded_str = "00000" + nr;
  return padded_str.substr(-1 * digits);
};

function f_section_name_parse(section_name) {
  // const section_shortname = section_name.replace(/Project: /, "").replace(/ \([0-9]+(m|h)\)/, "");
  const section_shortname = section_name
    .replace(/ \([0-9]+(m|h)\)/, "")
    .replace(/ /g, "-")
    .replace(/--/g, "-")
    .replace(/[^a-zA-Z0-9\-]/g, "");
  const section_tag = section_shortname.replace(/[^A-Z]/g, "");
  return { section_tag, section_shortname };
}

function f_lecture_name_parse(lecture_name) {
  const lecture_nr = lecture_name.replace(/^([0-9]+-])/, "$1");
  const lecture_zero_nr = ("000" + ~~parseInt(lecture_nr, 10)).slice(-2);
  const lecture_shortname = lecture_name
    .replace(/^[0-9]+\- /, "")
    .replace(/ /g, "-")
    .replace(/--/g, "-")
    .replace(/[^a-zA-Z0-9\-]/g, "");
  return { lecture_zero_nr, lecture_shortname };
}

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
//

async function fa_main() {
  const func_name = "fa_main()";
  console_log_debug(func_name, `start.`);
  //
  let file_list = [];
  let TAG = "";
  let course_name = "";
  //
  const stdin_json = await fa_read_stdin_into_string();
  //
  // console_log_debug(func_name, `stdin_json='${stdin_json}'`);
  //
  let stdin_obj;
  try {
    stdin_obj = JSON.parse(stdin_json);
  } catch (e) {
    // return console.error(e);
  }
  //
  if (stdin_obj) {
    TAG = stdin_obj?._jdg_meta?.TAG;
    course_name = stdin_obj?._jdg_meta?.course_name;
    //
    if (TAG && course_name) {
      //
      file_list.push(`${TAG}-s00-${tilde}${tilde}${course_name}.json`);
      file_list.push(`${TAG}-s00-${tilde}${tilde}${course_name}.xspf`);
      //
      let section_counter = 0;
      let lecture_counter = 0;
      //:
      const sections = stdin_obj?.user_syllabus;
      if (f_obj_is_array(sections)) {
        sections.forEach((sec) => {
          const section_name = sec?.name;
          if (section_name) {
            section_counter += 1;
            const { section_tag, section_shortname } = f_section_name_parse(section_name);
            //:
            const lectures = sec?.lectures;
            if (f_obj_is_array(lectures)) {
              lectures.forEach((lec) => {
                const lecture_name = lec?.name;
                const primary_attachment_type = lec?.primary_attachment_type;
                if (lecture_name && primary_attachment_type === "video") {
                  lecture_counter += 1;
                  const { lecture_zero_nr, lecture_shortname } = f_lecture_name_parse(lecture_name);
                  const section_zero_nr = f_nr_to_padzero_string(section_counter, 2);
                  let file_str = "";
                  if (lecture_counter == 1) {
                    file_str = `${TAG}-s${section_zero_nr}-${section_tag}-l${lecture_zero_nr}${tilde}${section_shortname}${tilde}${lecture_shortname}.mp4`;
                  } else {
                    file_str = `${TAG}-s${section_zero_nr}-${section_tag}-l${lecture_zero_nr}--${lecture_shortname}.mp4`;
                  }
                  file_list.push(file_str);
                }
              });
            }
            lecture_counter = 0;
            //.
          }
        });
      }
    }
    //.
  } // \if (stdin_obj) {}
  //
  const course_obj = {
    course_name,
    TAG,
    generator: "> cat REATSB/REATSB.json | ./download_mosh.js",
    file_list,
  };
  //
  // console_log_debug(func_name, "file_list = \n", JSON.stringify(file_list, null, 2));
  //
  console.log(JSON.stringify(course_obj, null, 2));
  //

  // stderr is sent to stderr of parent process
  // you can set options.stdio if you want it to go elsewhere
  let stdout;
  for (let file_name of course_obj.file_list) {
    stdout = execSync(`touch ${file_name}`);
  }
  //
}
fa_main();

// - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - . - - - - - - = = = - - - - - - .
// - - - - - - = = = - - - - - - .
//-eof

const example__json = {
  _jdg_meta: { download_url: "https://members.codewithmosh.com/layabout/current_user?course_id=2074069", TAG: "REATSI" },
  id: 62692488,
  gravatar_url: "https://s.gravatar.com/avatar/d3f8d40dad11bc8e6f57705696e309f6?d=mm",
  email: "john@de-graaff.net",
  name: "John-dG",
  role: "student",
  has_full_drip_access: false,
  enrolled_at: "2024-08-28T19:11:19Z",
  percent_complete: 0,
  access_limited_at: null,
  user_syllabus: [
    {
      id: 8862609,
      name: "1 - Getting Started (8m)",
      days_after_enrollment: null,
      release_date: null,
      is_dripped_by_date: false,
      lectures: [
        {
          id: 46678341,
          is_published: true,
          url: "/courses/ultimate-react-part2-1/lectures/46678341",
          name: "1- Introduction",
          duration: "1:02",
          type: "video",
          free_preview: true,
          days_after_enrollment: null,
          release_date: null,
          is_dripped_by_date: false,
          formatted_duration: "1:02",
          primary_attachment_type: "video",
          is_completed: false,
        },
      ],
    },
  ],
};

// - - - - - - = = = - - - - - - .
//-eof
