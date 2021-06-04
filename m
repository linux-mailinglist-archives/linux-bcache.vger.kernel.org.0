Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBC039B57F
	for <lists+linux-bcache@lfdr.de>; Fri,  4 Jun 2021 11:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbhFDJKo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 4 Jun 2021 05:10:44 -0400
Received: from mail-ej1-f48.google.com ([209.85.218.48]:33456 "EHLO
        mail-ej1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhFDJKn (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 4 Jun 2021 05:10:43 -0400
Received: by mail-ej1-f48.google.com with SMTP id g20so13472843ejt.0
        for <linux-bcache@vger.kernel.org>; Fri, 04 Jun 2021 02:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=lLFkY5er/ipnqGJEqSOTF3DZ5w8rz9NJ0EE9e7HHtTQ=;
        b=TB1qnCa17B0TSDomXG/mPO2D6cviZFBuCM3bORqELdkrhFtcn1lnFV8Qxw30HRho4r
         C+HAWgUwSpxKkXmPx2YduCkm4lDRe/7NWQ7ZqnFevhBlDuF+D/UgfdXqLSYD6cNXJPgl
         snNyxHY9G3ZvlSRixSm6IJQ++EsiZBKDSRd0V/+daBsXs/4FywSjKdpfYQ5sIWEtV5E6
         QpMyxwB+whexlZJ2n7zDn9fK2sS2F4jIWmpdt/jGzAnUWN4p99AAXiV0Iruhi7QvBdSo
         r0OqBamYNX8am8ZwX2Q//Tqz8813goIkqEACAWz95rH02p33BDDV4GjlGGmzAcrHGWUe
         rQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=lLFkY5er/ipnqGJEqSOTF3DZ5w8rz9NJ0EE9e7HHtTQ=;
        b=PZ3dFJRZjPQ08nen+Qo20d74JVh02Z5fioOv7oFqhi4pCgalDIQOTmLVMIFE8v1PEb
         RmEBHcZhTccLGh5F5bsH2I3BNgcxG0MC3Nb4zBv32BXcYSuTx0AwLbu06RLt263v9SSI
         cl7vzfAy2t/xYkLWG1nubaJ4aYNyddOWHs6awE/vucCU3OmR06Gbj7Wz0dmtQJUv1xId
         O4s6vyotO/4q7oSncRodzOTu78iQBTOo2ruDpUl1yDya9WDp8ooEmihu6higeHhpa7+E
         6IQ65lj491Uw37SU0lcTdB7i2zKcZZfSscdIGnjzV5KTJaSy2ajQfDTDWix+50VUYzH5
         n+mA==
X-Gm-Message-State: AOAM530ak0PA0A1nyvs+UHWexYJw9Dn27l5Etfa94IS8T0SG95TvV2zh
        vEdB5TzwSXHXMq8HUeaFRj8fr5iX6qt49g==
X-Google-Smtp-Source: ABdhPJz3K8XFZmstw3CrX4nb2bcFnFMGJJEbWDSsby56Y3yUGsApp6zktSfa5Fm7gG99CEK0/C34vQ==
X-Received: by 2002:a17:906:4d04:: with SMTP id r4mr3299088eju.76.1622797676940;
        Fri, 04 Jun 2021 02:07:56 -0700 (PDT)
Received: from home07.rolf-en-monique.lan (94-212-138-219.cable.dynamic.v4.ziggo.nl. [94.212.138.219])
        by smtp.gmail.com with ESMTPSA id v6sm2473270ejx.60.2021.06.04.02.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 02:07:56 -0700 (PDT)
Subject: Re: PROBLEM: bcache related kernel BUG() since Linux 5.12
To:     Coly Li <colyli@suse.de>, Thorsten Knabe <linux@thorsten-knabe.de>
Cc:     linux-bcache@vger.kernel.org
References: <58f92cd7-38d1-bc16-2b5f-b68b2db2233b@thorsten-knabe.de>
 <f2f917d5-330b-a5cc-cca1-fe79a32c2140@rolffokkens.nl>
 <7e3c8a62-71d4-11a7-5dd7-137c030f5aad@suse.de>
 <92f2fb24-0d19-939d-a37a-91b9c1da4ac1@thorsten-knabe.de>
 <2a37723c-bc91-351d-5b0e-e7d104f88141@rolffokkens.nl>
 <69319c4e-71fe-5c7d-955f-801fdb9d9cba@suse.de>
From:   Rolf Fokkens <rolf@rolffokkens.nl>
Message-ID: <5df1c881-02e9-f951-5dbd-016a390d8d54@rolffokkens.nl>
Date:   Fri, 4 Jun 2021 11:07:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <69319c4e-71fe-5c7d-955f-801fdb9d9cba@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly, Thorsten,

I survived 48 hours perfectly:

bash-5.0$ uptime
 10:45:53 up 2 days, 11:05,  1 user,  load average: 2.82, 3.45, 2.67
bash-5.0$ cat /proc/version
Linux version 5.12.8-200.rf.fc33.x86_64
(mockbuild@tb-sandbox-mjolnir.local.tbai.nl) (gcc (GCC) 10.3.1 20210422
(Red Hat 10.3.1-1), GNU ld version 2.35-18.fc33) #1 SMP Tue Jun 1
23:10:39 CEST 2021
bash-5.0$

Furthermore there are no concerning messages in the syslog.

Best,

Rolf

On 6/2/21 1:08 PM, Coly Li wrote:
> On 6/2/21 5:45 PM, Rolf Fokkens wrote:
>> Hi Coli,
>>
>> Things are stable so far, looks really promising:
>>
>> bash-5.0$ cat /proc/version
>> Linux version 5.12.8-200.rf.fc33.x86_64
>> (mockbuild@tb-sandbox-mjolnir.local.tbai.nl) (gcc (GCC) 10.3.1 20210422
>> (Red Hat 10.3.1-1), GNU ld version 2.35-18.fc33) #1 SMP Tue Jun 1
>> 23:10:39 CEST 2021
>> bash-5.0$ uptime
>>  11:42:05 up 12:01,  1 user,  load average: 0.84, 2.43, 3.20
>> bash-5.0$
>>
>> I left the system running during the night, and have been using it
>> actively for 3 hours now.
>
> Hi Rolf and Thorsten,
>
> Thank you all for the status update!
>
>> I'll keep you posted if anything changes, but this is a major step
>> forward for sure (before your patches the system would freeze in minutes
>> after booting).
>
> Hope we have the luck in next 48 hours.
>
> Coly Li


