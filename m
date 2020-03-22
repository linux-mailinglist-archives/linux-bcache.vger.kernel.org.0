Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEA818EA06
	for <lists+linux-bcache@lfdr.de>; Sun, 22 Mar 2020 17:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgCVQHo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sun, 22 Mar 2020 12:07:44 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34876 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgCVQHo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sun, 22 Mar 2020 12:07:44 -0400
Received: by mail-pg1-f193.google.com with SMTP id 7so5872830pgr.2
        for <linux-bcache@vger.kernel.org>; Sun, 22 Mar 2020 09:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Cllw+Acf1/zDGvW1OVmILYynNne/WJT+QGIYuOy4cYQ=;
        b=XgrfzTMPyGWpYonyMLlkivFygz+4cfbqZuI6hehzYiLTyOo48DT/O1Rt1nIXmC7jrJ
         cjSsmXXzyJGtUrNJ2Yta7qkNVD6/Z8xVtumU+RUVKrOxzKIdSghRgKAy+gylFCW4UUA0
         +ZxX3IhOGpbWKJTkobZfkZ+nPuMUfE8gKMtWGzVzg05vTRi4d+i2E0yDKpROGFhk2KxH
         svU2C8YxjO3132uzM8VG/nazrHRcbZDpOUUXZ0Qiyz04nUhNbv5nw9V3Ts5klUW8/zAc
         6zIi20HgHAtL6tv7egc6F4mC3g6cBSN4HLCy9+VrE6iCYaBuYw/VORaMlON9tgIr17IJ
         11qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Cllw+Acf1/zDGvW1OVmILYynNne/WJT+QGIYuOy4cYQ=;
        b=OBEub0zJzycxdUW9VKf1J1Mpzk6cGwa7JEQSmycZhEazZ6XBT1gCYpbm+5GeaUwtgl
         istcknRXY0ItNZI+dlldm4+ZuY4s21xU7wQM/nKc5YxQMzAZrHt6+h+jXxWfr2UHlMTa
         Uj4o49k6o0aI/+IyIPIKzoQnJidctLrk1oEoXBuAVhJZpXULgpxh4mv01Ql2IyYHyPiv
         gKjihivzDbqu0f1fet6s67kEI9tAIZpy21/uDPzpcQxKsURO9xHhl8CHXOqbpQV1hG++
         47G13WeIsqJy+RrX7gz1+dMycMlYSydvyVbGi782l7iQ7REXsflCkCmLrcu8i4QWBYK8
         RvUg==
X-Gm-Message-State: ANhLgQ1X35AsPpIhr9dhG6V+njYHAH32YUZ8N/5QUL7Ojz91bt4Vp4BT
        cxukJ0yOcVGknGAH2BB1s8mbcQ==
X-Google-Smtp-Source: ADFU+vtM5c1iiEMd+6SFCOef+T/gmQuzEyQ+klThEpY51RCqUgDDJUtlavFz9g4MHcgdDXOCuPf5Zw==
X-Received: by 2002:aa7:848b:: with SMTP id u11mr19717978pfn.76.1584893262820;
        Sun, 22 Mar 2020 09:07:42 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y15sm11099322pfc.206.2020.03.22.09.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 09:07:42 -0700 (PDT)
Subject: Re: [PATCH 0/7] bcache patches for Linux v5.7-rc1
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200322060305.70637-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <61344bad-e454-1827-c0bc-038f7e73dc16@kernel.dk>
Date:   Sun, 22 Mar 2020 10:07:35 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200322060305.70637-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/22/20 12:02 AM, Coly Li wrote:
> Hi Jens,
> 
> These are bcache patches for Linux v5.7-rc1.
> 
> The major change is to make bcache btree check and dirty secrtors
> counting being multithreaded, then the registration time can be
> much less. My first four patches are for this purpose.
> 
> Davidlohr Bueso contributes a patch to optimize barrier usage for
> atomic operations. By his inspiration I also compose a patch for
> the rested locations to change.
> 
> Takashi Iwai contributes a helpful patch to avoid potential
> buffer overflow in bcache sysfs code path.
> 
> Please take them, and thank you in advance.

Applied, thanks.

-- 
Jens Axboe

