Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09F6195AEE
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 17:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727585AbgC0QSz (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 12:18:55 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:40038 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgC0QSy (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 12:18:54 -0400
Received: by mail-pl1-f179.google.com with SMTP id h11so3618044plk.7
        for <linux-bcache@vger.kernel.org>; Fri, 27 Mar 2020 09:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UquzxbwmO78QKCJ8GvUGG+PHBO9lh8BRRDLn/bTE84s=;
        b=DkxLtJJ61uWVyKpBlbNQrHrYvOYuLDf8xNt4TLZ+KPWUyj+lJosKVG22FtvtiB6yf/
         HQxg1JsJgQ2oQpC0RGq2WENmA+Y5oMA9RvVsfM0Za8v9w5z0lkMo0aqPQ+21Fsp2XahU
         2IBybYChfgjVaPCyFtWaqk418x/IJdXYnbjxBnzHnyitlujPApriYfEofNwR+hKwiMLN
         TZAISXMZvXlR7a/EI66fJcI4ZilnOIdRjiYk5RMLdhTpKTkcOiGWamKMO7bjEsnojK95
         DvgdvidNJdagQkU7HOe1hbjP8UvoUQVgg0mGD42U8fj9fuA+FTimVeWJ9UyO1jfuK+Ad
         9mHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UquzxbwmO78QKCJ8GvUGG+PHBO9lh8BRRDLn/bTE84s=;
        b=TldVBxsmnKwFGa5MTHRbG6GH8XcjgMCIne11vTk+dpndt4wIvGWtvEIVOZI+L5CuFR
         CGaRfGE2hybgcqgyjWRr3Km4LQQzWPK0MWSs2kyP53FBSKWMA2gUR1ZVIUK3Vh0f4L3d
         jqtCsqETtGZ9gGWeJ7N+yV0N8FPSM21Ub36cmgKA+/yMnQmz1y3LSLNEZzeSwzA5+i7M
         r2D5O0mELyePYYV4EKQJaX8sdoEZ/rlWtANXISAzUVgsx/4LQk/9pirR3Hntp9Ectz3o
         jMvlZEgvDTPzio8zkOatUE+A+LtOfDwg/rL2fPXr25ZssJRIPg4703gQmlhrYhBqo5gI
         c7WQ==
X-Gm-Message-State: ANhLgQ37pR+gPDeM//cQ9nzcsj02HYN0nul5AmX5btlQ+tDQPnuN5c/B
        btHAu+7A+/1lL+wWCsxj13IYiA==
X-Google-Smtp-Source: ADFU+vuVl9MB2Gp7aINk2gq8j89Z73xugxEyUifYbhIbdWR0EkZLXaGJ8Y9aD9YArtjcEwWNDNr8dA==
X-Received: by 2002:a17:902:40a:: with SMTP id 10mr13517789ple.183.1585325933514;
        Fri, 27 Mar 2020 09:18:53 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id v14sm4459229pff.30.2020.03.27.09.18.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 09:18:52 -0700 (PDT)
Subject: Re: simplify queue allocation
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200327083012.1618778-1-hch@lst.de>
 <b1123d19-0c4a-5d3d-d0d4-0a412830c2b0@kernel.dk>
 <20200327161754.GA19480@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <21bb5f8e-d395-c8fe-bf08-00e4f37cbb69@kernel.dk>
Date:   Fri, 27 Mar 2020 10:18:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200327161754.GA19480@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/27/20 10:17 AM, Christoph Hellwig wrote:
> On Fri, Mar 27, 2020 at 09:53:16AM -0600, Jens Axboe wrote:
>> On 3/27/20 2:30 AM, Christoph Hellwig wrote:
>>> Hi Jens,
>>>
>>> this series ensures all allocated queues have a valid ->make_request_fn
>>> and also nicely consolidates the code for allocating queues.
>>
>> This seems fine to me, but might be a good idea to shuffle 4/5 as the
>> last one, and do that one inside the merge window to avoid any potential
>> silly merge conflicts.
> 
> they should be trivial to reorder if you want to skip patch 4 for now.
> But looking at current linux-next there isn't any conflict yet,
> and I don't expect one as most block drivers go through the block
> tree anyway.

Yeah I guess so, and any potential conflict would be trivial. I'll apply
it and hope for the best.

-- 
Jens Axboe

