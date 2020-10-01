Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E483F280956
	for <lists+linux-bcache@lfdr.de>; Thu,  1 Oct 2020 23:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbgJAVTF (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 1 Oct 2020 17:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgJAVTF (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 1 Oct 2020 17:19:05 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF757C0613D0
        for <linux-bcache@vger.kernel.org>; Thu,  1 Oct 2020 14:19:04 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x22so5825810pfo.12
        for <linux-bcache@vger.kernel.org>; Thu, 01 Oct 2020 14:19:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SAwKMJiLJm9woSPLGj2oZyxL8Pd3LiVTlPfw3kBCbL8=;
        b=CUdPD9TMwPgL/8jhsHqF0DhBdUP4hGZzuBRBTN0hYCVyFhGheNrhTxONiDXutu/GLp
         FaZxlJB5lCzPlQ6t605NQbSF3I7v0Ib+j6jIi6md9nsKPSJ45NlnXX6xgHBgYCdJVMKS
         1f0hbojYLaSH2Pyql9SC0kj686J3yiQ2+7A3jXKTWM5bLhDY7zRvuGpZpQA/OuJO/oNZ
         oXLRJ3ubHxfOUG6WJoNbJ5upOUc6EeN5rQcpntiAdWjpCzv5tScIIGkQEgP11eHlohrt
         TPyKbXlAWBPO+FyGA5aIdHr927xZs+/KnQL6Y+Q55dKgNDgsAQlStusW+nZgtnJ1QQ1t
         XIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SAwKMJiLJm9woSPLGj2oZyxL8Pd3LiVTlPfw3kBCbL8=;
        b=QIXm5qK40JTfgqAOYSZRhdw61NAn9HkhsfpCdBMh8LkihtwVWyMqax4bHqqLAih4bv
         6u5tdKu37j1fYt4DbWPkEhApfWd/e3J6lVA7m8ZLo+mO55bQpG5yIyW5wB/O2o1+iGTU
         hBMj0xxibAB2XsKJ+fB2lAnglk5os+s9JvlNlh4+PSqAb3BTqKn7EX1PRUZT9vsUo+Tr
         sN7+0XWvpYKYOXd9C9NSCKlv6+HVk1dBcLmsJX2IxoxYDS+oQPQ6m9R78Z+D3boigr2l
         GxT8EidAsoFIZBySlCv9PAiCp8ZO2cNIlF0MTeP9Dd4FjSE3FB0EI4Z5IzNXQMynQ1DM
         SwHA==
X-Gm-Message-State: AOAM533HWjzMectq2JPJgqvUqFSwPrpPtDe1+t59b7byVLKWM/TT81qu
        pFOjZFzuhcHG4y65rksAC30lLw8E46Wl2d7z
X-Google-Smtp-Source: ABdhPJyqvWLa125YOUGy02MY1Vte3qjLISz1r/stVSQPgkwaUo9KxPfljH0YBs4wOeif0kiL2HEJzw==
X-Received: by 2002:aa7:8bd4:0:b029:13c:1611:6538 with SMTP id s20-20020aa78bd40000b029013c16116538mr6427782pfd.10.1601587144490;
        Thu, 01 Oct 2020 14:19:04 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x13sm7166921pff.152.2020.10.01.14.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 14:19:03 -0700 (PDT)
Subject: Re: [PATCH 01/15] bcache: share register sysfs with async register
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20201001065056.24411-1-colyli@suse.de>
 <20201001065056.24411-2-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fc456508-e139-98cc-45bc-4649ae5381b4@kernel.dk>
Date:   Thu, 1 Oct 2020 15:19:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201001065056.24411-2-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 10/1/20 12:50 AM, Coly Li wrote:
> Previously the experimental async registration uses a separate sysfs
> file register_async. Now the async registration code seems working well
> for a while, we can do furtuher testing with it now.
> 
> This patch changes the async bcache registration shares the same sysfs
> file /sys/fs/bcache/register (and register_quiet). Async registration
> will be default behavior if BCACHE_ASYNC_REGISTRATION is set in kernel
> configure. By default, BCACHE_ASYNC_REGISTRATION is not configured yet.

Will this potentially break existing use cases?

-- 
Jens Axboe

