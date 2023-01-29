/*
 * SPDX-FileCopyrightText: Copyright © 2020-2023 Serpent OS Developers
 *
 * SPDX-License-Identifier: Zlib
 */

/**
 * cv.js
 *
 * JS support for the CV application
 *
 * Authors: Copyright © 2020-2023 Serpent OS Developers
 * License: Zlib
 */

window.addEventListener('load', function(ev)
{
    const promises = [
        loadJobs()
    ];
    Promise.allSettled(promises).then(([jobs]) => {
        renderJobs(jobs);
    }).catch((e) => console.log(e));
});

function loadJobs()
{
    return fetch('/jobs.json', {
        method: 'GET',
        credentials: 'omit'
    }).then((o) => {
        if (!o.ok) {
            throw new Error(`Unable to fetch jobs: : ${o.statusText}`);
        }
        return o.json();
    });
}

function renderJob(job)
{
    console.log(job);
    return `
<div class="list-group-item">
    <div class="row">
        <div class="col-3 px-3">
            <div class="text-muted">${job.when}</div>
            <div>${job.position} @ ${job.company}</div>
        </div>
        <div class="col-9">
            <p class="lead">${job.description}
        </div>
    </div>
</div>`;
}

function renderJobs(jobs)
{
    const target = document.getElementById('jobList');
    target.innerHTML = Array.prototype.map.call(jobs.value, (i) => renderJob(i)).join(' ');
}