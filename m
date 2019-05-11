Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41DDC1A725
	for <lists+linux-bcache@lfdr.de>; Sat, 11 May 2019 10:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfEKIGe (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 11 May 2019 04:06:34 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:45206 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728397AbfEKIGe (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 11 May 2019 04:06:34 -0400
Received: by mail-ed1-f45.google.com with SMTP id g57so8651222edc.12
        for <linux-bcache@vger.kernel.org>; Sat, 11 May 2019 01:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rolffokkens-nl.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=6s2PMwyFAJrUBo+eR6c+whzyeoS0UftC/8A+9BTkRg0=;
        b=WJW+IFOdtTiIcqatBqpRSh0L6EPa7+Bahuegw5JWspta16outmRuy91WDlDTOYcFjV
         mOLkdk7+ImsSHVRUuVeWEi5pXopxMsQd+jby21+VQHoi0J2lVrs9uNCsuwlQPrxMLMty
         I74aLzrgPzux5Wt4KAQ8JURCO/l6NWifphyUvKqwAWCeIgHGq94NEI2lIwEhXMAqynGx
         U5cJLp7OWL2fgbtCbgyAr0hn9LwT/1WUfPK5S3MA2r4RSgV8qSuTrQuGDX0dTCflVBO+
         mV9uUGDu3IMsSaq18DwIlTEkdOPi2qJ2d9XQ0fAkr0Wu0IH788r+Zcv6Vn0o3KlDbWH6
         5gfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6s2PMwyFAJrUBo+eR6c+whzyeoS0UftC/8A+9BTkRg0=;
        b=mcQZp8zEkN716NR/naTZbHe0Fnl179R+jPVQEvtnTh2odfEQ5d2bKNSS4OzUx+aqrs
         rHh++diBExko2V195wWTJetHooYcwSjhqavP+NJf+mSjy46Jx7UgN0RlpwjlDNOhF2Vr
         sanLOcYmRJihkcE0Bh9AzagcmYIuyyhqMQ62FTo1MbZFZo1Qt4Vr7DZSY1u5CFyCGf16
         IbyXjSapYo4ZC2MkRhuAzn+V1iwCnPAh58k7BXbaBwmLI2My/bWlN04bne4EDOn0FSQS
         Ar2v/+9foKYs56WQIiHXxgpYt1kFvmUqwh6T9U/H6L+QCtJcNWwKu/TeAfiq5BXZGhZg
         zvYg==
X-Gm-Message-State: APjAAAWh9xgw4ODFoLlIdwWS9+FDQCFih0xuw/TN3m5vp22BOh7v4M3A
        biMcspwo3tJVEg2moWLP6nT45ajRwxo=
X-Google-Smtp-Source: APXvYqxM+v+G02Nj5v+pYsdJiSyemAwwh4fHvuITPRPpn8Xsimn5dtB+vTjYlNeTcSsXS7O/3+GOXQ==
X-Received: by 2002:a50:8e8f:: with SMTP id w15mr16547733edw.218.1557561991885;
        Sat, 11 May 2019 01:06:31 -0700 (PDT)
Received: from home07.rolf-en-monique.lan ([89.188.16.145])
        by smtp.gmail.com with ESMTPSA id w4sm2029283edf.89.2019.05.11.01.06.30
        for <linux-bcache@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 01:06:30 -0700 (PDT)
Subject: Re: bcache & Fedora 30: massive corruption 100% reproducable
From:   Rolf Fokkens <rolf@rolffokkens.nl>
To:     linux-bcache@vger.kernel.org
References: <dfa0b47d-a1c6-3faa-b377-48677502a794@rolffokkens.nl>
 <6d386198-49d0-495e-a8d1-1bc7d0191bee@rolffokkens.nl>
Message-ID: <ed7ad425-6dcc-d2de-d22a-053a8c3bcd10@rolffokkens.nl>
Date:   Sat, 11 May 2019 10:06:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <6d386198-49d0-495e-a8d1-1bc7d0191bee@rolffokkens.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: nl-NL
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

FYI:

https://bugzilla.kernel.org/show_bug.cgi?id=203573
https://bugzilla.redhat.com/show_bug.cgi?id=1708315

On 5/9/19 7:21 PM, Rolf Fokkens wrote:
> Hi,
>
> The reproducability is 100%. It's enough to only upgrade to a Fedora 
> 30 kernel on a Fedora 29 system. The next reboot will probably be the 
> last reboot ever.
>
> My Fedora bug report is here:
>
> If it's gcc9 related, the cause may be somewhere between "Fedora's 
> decision to use gcc9" and "bcache needing a fix".
>
> Rolf
>
> On 5/6/19 7:45 PM, Rolf Fokkens wrote:
>>
>> Hi,
>>
>> I helped in 2013 to get bcache-tools integrated in Fedora 21 
>> (https://lists.fedoraproject.org/archives/list/devel@lists.fedoraproject.org/thread/UEGAUSP377TB3KMUO7XK42KREHOUDZPG/).
>>
>> Ever since it worked like a charm, and bcache laptops (we have 
>> several at work) survived upgrading to a next Fedora release 
>> flawlessly. Since Fedora 30 this has changed however: laptops using 
>> bcache mess up backing store big time. It seems as if the backing 
>> device is corrupted by random writes all over the place. It's hard to 
>> narrow down the cause of this issue, and I'm still in the process of 
>> trial and error. May be later on I'll have more info.
>>
>> Some info:
>>
>>   * The laptops are using writeback caching
>>   * The laptops have a bcache'd root file system
>>   * It seems like the issue is in the Fedora kernel 5.0.10 for Fedora
>>     30, but not kernel 5.0.10 for Fedora 29.
>>   * One notable difference between the Fedora 29 and Fedora 30 kernels
>>     is that Fedora 30 uses gcc 9 to build the kernel.
>>
>> As mentioned i'm still in the process of narrowing down the cause of 
>> the issue. But any suggestions are welcome.
>>
>> Rolf
>>
>

