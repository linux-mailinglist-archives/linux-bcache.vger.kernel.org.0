Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FEE302A4C
	for <lists+linux-bcache@lfdr.de>; Mon, 25 Jan 2021 19:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbhAYScK (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 25 Jan 2021 13:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbhAYScG (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 25 Jan 2021 13:32:06 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734AFC061756
        for <linux-bcache@vger.kernel.org>; Mon, 25 Jan 2021 10:31:26 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id g15so140435pjd.2
        for <linux-bcache@vger.kernel.org>; Mon, 25 Jan 2021 10:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fj+Mfh+iRTxHQ178jS8NvM3lFwTcOTHpKQTHJjUZLmQ=;
        b=NdQRadAEr90lOki82TN6DFtvOSfUjjxSRo0YnI+9kABgrnXatJDaUbKH+9fZNKlj37
         8v87B8qPFNTO01QF4Z+jIs5WJSNxzD33TVTDgtv3nEZ0w4x9IK0JXeObsgFXpyWnJclh
         r1MPwMoLp0LwM1UHh5fYunKmOYFttusTDMogxqlA60ejvcSjL5+cjWapnKTGwkLE1WBl
         +wecUym331pkGeIW1V+NRLHgryE1s5ac1/KqEetgGSVYiji7zS/TssjK7ZHThlzIZPks
         OzM9LBWUFP8lxX7V4KXEiIL3WHyGamsVVlVK0jNWsvr2a+VU1wTnQ8QTxvk6YIBylWd2
         kcYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fj+Mfh+iRTxHQ178jS8NvM3lFwTcOTHpKQTHJjUZLmQ=;
        b=q4FTfdRRIkNUMPon5poEEx+hng+XfM4RnIGL15t4D0NX8SsFOLpqg3pj9oxpDVYlDc
         RlBZ7oxOVg9gskACyClzxGc+7KjiPms77x3tuf4VOrWDEWut8/xDUdPu6iWSZDzP9IdT
         j9wIxGTAIDaa9EBsel9pGU6sicbo9488++VR4NshiekI31qNQwW7JEDLtA7GSv5BEQAz
         SOXc+OaSDSMRmCorMVfzWxtI0W6rXnkhhT3ctQ/TjtoVUsl/HTo/njj5LqRYf9rVjzJc
         RmAlPiaS8uky7izHAmbXP/vOPNReWDH+E62DMn8YGABX8FzmEu+iNSiWQwAsmRiA5z2w
         STXg==
X-Gm-Message-State: AOAM531n9U40QWzcKKmU7P9Ee02y3N2WpPl4MxwM4eVaCNtNw4tJus6x
        d1cijxicEwNruNyOMzOXo3mlUA==
X-Google-Smtp-Source: ABdhPJw45UKblJYIjAuYyqjrm84zW5HcAl4q2OlrL0kcx51YsGL6Wwv5aF+a7froFnxQYB/1Z5yYqg==
X-Received: by 2002:a17:902:b717:b029:dc:3e69:6dd5 with SMTP id d23-20020a170902b717b02900dc3e696dd5mr1995124pls.70.1611599485884;
        Mon, 25 Jan 2021 10:31:25 -0800 (PST)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id 24sm10567912pgt.14.2021.01.25.10.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jan 2021 10:31:25 -0800 (PST)
Subject: Re: [PATCH 05/10] block: do not reassig ->bi_bdev when partition
 remapping
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
References: <20210124100241.1167849-1-hch@lst.de>
 <20210124100241.1167849-6-hch@lst.de>
 <dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk>
 <20210125175528.GA13451@lst.de>
 <2b600368-96fa-7caf-f05b-321de616f7c9@kernel.dk>
 <13667b22-029b-d7be-02da-96fce22cfd8f@kernel.dk>
 <20210125181349.GA14432@lst.de>
 <1c0fabdc-9b73-dfd7-f49d-c211d58cbf12@kernel.dk>
 <20210125181826.GA14957@lst.de>
 <22e0f687-3165-e9d1-e1bd-9769a11dc0ea@kernel.dk>
 <20210125182150.GA15367@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <387c824a-c713-a087-2f6f-434ba127b1df@kernel.dk>
Date:   Mon, 25 Jan 2021 11:31:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210125182150.GA15367@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 1/25/21 11:21 AM, Christoph Hellwig wrote:
> On Mon, Jan 25, 2021 at 11:19:23AM -0700, Jens Axboe wrote:
>> On 1/25/21 11:18 AM, Christoph Hellwig wrote:
>>> On Mon, Jan 25, 2021 at 11:15:04AM -0700, Jens Axboe wrote:
>>>> On 1/25/21 11:13 AM, Christoph Hellwig wrote:
>>>>> On Mon, Jan 25, 2021 at 11:03:24AM -0700, Jens Axboe wrote:
>>>>>> Partition table entries are not in disk order.
>>>>>
>>>>> And the issue shows up with the series just up to the this patch,
>>>>> without any later patches?
>>>>
>>>> At that patch specifically. I bisected it, and then I double checked
>>>> by running the previous commit (boots fine), then apply this one, and
>>>> then I run into that error. So it should be 100% reliable.
>>>
>>> Ok, I have an idea.  With EOD message you mean this printk, right:
>>>
>>> 	pr_info_ratelimited("attempt to access beyond end of device\n"
>>>                             "%s: rw=%d, want=%llu, limit=%llu\n",
>>> 			    ...
>>>
>>> right?
>>
>> Yep
> 
> Can you give this untested patch a spin?  This should fix the
> case where we check the eod for the original partition with the
> remapped bi_sectors.  Looking into a local reproducer now.

Yep, with that applied on top my laptop boots again.

-- 
Jens Axboe

