Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14CE121343
	for <lists+linux-bcache@lfdr.de>; Fri, 17 May 2019 06:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfEQEyS (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 17 May 2019 00:54:18 -0400
Received: from smtp6.tech.numericable.fr ([82.216.111.42]:38044 "EHLO
        smtp6.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfEQEyS (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 May 2019 00:54:18 -0400
Received: from pierre.juhen (89-156-43-137.rev.numericable.fr [89.156.43.137])
        by smtp6.tech.numericable.fr (Postfix) with ESMTPS id 1DE701820CE;
        Fri, 17 May 2019 06:54:16 +0200 (CEST)
Subject: Re: Critical bug on bcache kernel module in Fedora 30
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     kent.overstreet@gmail.com
References: <8ca3ae08-95ce-eb3e-31e1-070b1a078c01@orange.fr>
 <b0a824da-846a-7dc6-0274-3d55f22f9145@suse.de>
 <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
From:   Pierre JUHEN <pierre.juhen@orange.fr>
Message-ID: <3204ad50-9340-1ad6-9b72-cf7a70737d09@orange.fr>
Date:   Fri, 17 May 2019 06:54:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5cdfb1f7-a4b5-0dff-ae86-e5b74515bda9@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: fr-FR
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtuddgkeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfdpqfgfvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomheprfhivghrrhgvucflfgfjgffpuceophhivghrrhgvrdhjuhhhvghnsehorhgrnhhgvgdrfhhrqeenucfrrghrrghmpehmohguvgepshhmthhpohhuthenucevlhhushhtvghrufhiiigvpedt
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

HI again,

> I looked a bit on the code (maybe an old version), however, I saw in the macro defined by btree.c definition of variables of int type.

Could it be a change in GCC, where the default int move from short to 
long and did have side effects ?

Regards,


