Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCCA014F82B
	for <lists+linux-bcache@lfdr.de>; Sat,  1 Feb 2020 15:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgBAO6P (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Sat, 1 Feb 2020 09:58:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44748 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgBAO6P (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Sat, 1 Feb 2020 09:58:15 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so5205281pgl.11
        for <linux-bcache@vger.kernel.org>; Sat, 01 Feb 2020 06:58:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V+84GWr3lNxKTeqdrIO3Ly1rWoYrT/g923krQ6rxDLw=;
        b=nttcNARINoiVnToJQunZTfaUhhCBA/lUHMZKSsL/PkfJQDSSmbsIzYDmu7Jy0+zWZS
         Bib1xY7D1kZwY5XL/ggpmVqhw10/GXgDwV/LhiKMcvRT8n99ISMJSX6PP0Bc+4Mz9ArH
         DjCQ/FjvH+aJXKjKOpKMmgjYKT2Abq/rrLrSXCUxT/MoytsQhT/mlocpypg7i5b7F22V
         4mmWS9tBntu8EMIzywFqr6P1UiOK4MayR8mXM2aCRRykVQh58zHoXPQCnERgLLbJAzYt
         ctIpXqASP4qjy8u0N1CgV6TYPlwvcBCcdpsufRu1QoXrps4DZu+uoGevjeyglWDwkvCV
         F0iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V+84GWr3lNxKTeqdrIO3Ly1rWoYrT/g923krQ6rxDLw=;
        b=TWwFa5/o361FuQBKj9Rf027U74Ao1X12b3RKzukmAI9fRB/jY18ZJqPJVIA2ZJI4k5
         lOArug/gzklbHMpAV7OWeKI7WdfwEXOyzVsAg2RgNiMsrNvY5osb6AdCYpddiPr6jsrh
         hcm5gEcNqEEq60CXrKWtzNt6BhF2JlMB/wMujfUGR0NtbKSfInS3V09hvXTBojoZh8at
         mpZoAQtKI+yg4CcW02NLxBYFMErwQ/rOZkvu/gGVRkLEkJes/6zvb+xf+KwcbGHBz6MW
         NvarARPdNacEkVGb4g8HMWwsOx7V/GLaJqHY3mZ6BJ0sAQE/A0TOEzm+jHXeN8E/pb0Q
         /qug==
X-Gm-Message-State: APjAAAV8A5FPzmUMCFEB/ENqeKL7ZBUxmxKH6XKaEURof88E0lzt8WO2
        uv4m5ujSjakVSYzEv+g7ki5lBg==
X-Google-Smtp-Source: APXvYqy+LLvTgvNXz+iQuaKSqdszQer18XNv+HwNu+J3eA4SeYPHlNcmFIxZUipJFZqyTHWyJG79CQ==
X-Received: by 2002:a63:ce55:: with SMTP id r21mr15390338pgi.156.1580569093462;
        Sat, 01 Feb 2020 06:58:13 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id r3sm14648747pfg.145.2020.02.01.06.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2020 06:58:13 -0800 (PST)
Subject: Re: [PATCH 0/5] bcache patches for Linux v5.6-rc1
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
References: <20200201144235.94110-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fee4f649-eb8a-e7af-70d6-ad75e9a4c8bc@kernel.dk>
Date:   Sat, 1 Feb 2020 07:58:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201144235.94110-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/1/20 7:42 AM, Coly Li wrote:
> Hi Jens,
> 
> Here are the bcache patches for Linux v5.6-rc1. All the patches are
> tested and survived my I/O pressure tests for 24+ hours intotal.
> 
> Please take them. Thank you in advance.

Applied for 5.6, thanks.

-- 
Jens Axboe

